
#include "lulesh.h"
#include "lulesh-dash.h"
#include "lulesh-comm-mpi.h"

Comm::Comm(Domain& dom) : m_dom(dom)
{
  // allocate a buffer large enough for nodal ghost data
  Index_t maxPlaneSize = CACHE_ALIGN_REAL( dom.maxPlaneSize() );
  Index_t maxEdgeSize  = CACHE_ALIGN_REAL( dom.maxEdgeSize()  );

  // assume communication to 6 neighbors by default
  Index_t rowMin   = (m_dom.rowLoc() == 0)               ? 0 : 1;
  Index_t rowMax   = (m_dom.rowLoc() == m_dom.tp(1)-1)   ? 0 : 1;
  Index_t colMin   = (m_dom.colLoc() == 0)               ? 0 : 1;
  Index_t colMax   = (m_dom.colLoc() == m_dom.tp(2)-1)   ? 0 : 1;
  Index_t planeMin = (m_dom.planeLoc() == 0)             ? 0 : 1;
  Index_t planeMax = (m_dom.planeLoc() == m_dom.tp(0)-1) ? 0 : 1;

  // account for face communication
  Index_t comBufSize =
    (rowMin + rowMax + colMin + colMax + planeMin + planeMax) *
    maxPlaneSize * MAX_FIELDS_PER_MPI_COMM ;

  // account for edge communication
  comBufSize +=
    ((rowMin & colMin) + (rowMin & planeMin) + (colMin & planeMin) +
     (rowMax & colMax) + (rowMax & planeMax) + (colMax & planeMax) +
     (rowMax & colMin) + (rowMin & planeMax) + (colMin & planeMax) +
     (rowMin & colMax) + (rowMax & planeMin) + (colMax & planeMin)) *
    maxEdgeSize * MAX_FIELDS_PER_MPI_COMM ;

  // account for corner communication
  // factor of 16 is so each buffer has its own cache line
  comBufSize += ((rowMin & colMin & planeMin) +
		 (rowMin & colMin & planeMax) +
		 (rowMin & colMax & planeMin) +
		 (rowMin & colMax & planeMax) +
		 (rowMax & colMin & planeMin) +
		 (rowMax & colMin & planeMax) +
		 (rowMax & colMax & planeMin) +
		 (rowMax & colMax & planeMax)) * CACHE_COHERENCE_PAD_REAL ;

  this->commDataSend = new Real_t[comBufSize];
  this->commDataRecv = new Real_t[comBufSize];

  // prevent floating point exceptions
  memset(this->commDataSend, 0, comBufSize*sizeof(Real_t));
  memset(this->commDataRecv, 0, comBufSize*sizeof(Real_t));
}

Comm::~Comm()
{
  delete[](commDataSend);
  delete[](commDataRecv);
}

void Comm::ExchangeNodalMass()
{
  Domain_member fieldData;
  fieldData = &Domain::nodalMass;

  Comm& comm = *this;
  Domain&  dom  = m_dom;

  // Initial domain boundary communication
  CommRecv(dom, comm, MSG_COMM_SBN, 1,
	   dom.sizeX() + 1, dom.sizeY() + 1, dom.sizeZ() + 1,
	   true, false);
  CommSend(dom, comm, MSG_COMM_SBN, 1, &fieldData,
	   dom.sizeX() + 1, dom.sizeY() + 1, dom.sizeZ() +  1,
	   true, false);
  CommSBN(dom, comm, 1, &fieldData);

  // End initialization
  MPI_Barrier(MPI_COMM_WORLD);
}

void Comm::Recv_PosVel()
{
  Comm& comm = *this;
  Domain&  dom  = m_dom;

  CommRecv(dom, comm, MSG_SYNC_POS_VEL, 6,
	   dom.sizeX() + 1, dom.sizeY() + 1, dom.sizeZ() + 1,
	   false, false);
}

void Comm::Send_PosVel()
{
  Domain_member fieldData[6];

  fieldData[0] = &Domain::x;
  fieldData[1] = &Domain::y;
  fieldData[2] = &Domain::z;
  fieldData[3] = &Domain::xd;
  fieldData[4] = &Domain::yd;
  fieldData[5] = &Domain::zd;

  Comm& comm = *this;
  Domain&  dom  = m_dom;

  CommSend(dom, comm, MSG_SYNC_POS_VEL, 6, fieldData,
	   dom.sizeX() + 1, dom.sizeY() + 1, dom.sizeZ() + 1,
	   false, false);
}

void Comm::Sync_PosVel()
{
  Comm& comm = *this;
  Domain&  dom  = m_dom;

  CommSyncPosVel(dom, comm);
}

void Comm::Recv_Force()
{
  Comm& comm = *this;
  Domain&  dom  = m_dom;

  CommRecv(dom, comm, MSG_COMM_SBN, 3,
           dom.sizeX() + 1, dom.sizeY() + 1, dom.sizeZ() + 1,
           true, false);

}

void Comm::Send_Force()
{
  Comm& comm = *this;
  Domain&  dom  = m_dom;
  Domain_member fieldData[3];
  fieldData[0] = &Domain::fx;
  fieldData[1] = &Domain::fy;
  fieldData[2] = &Domain::fz;

  CommSend(dom, comm, MSG_COMM_SBN, 3, fieldData,
           dom.sizeX() + 1, dom.sizeY() + 1, dom.sizeZ() +  1,
           true, false);
}

void Comm::Sync_Force()
{
  Domain_member fieldData[3];
  fieldData[0] = &Domain::fx;
  fieldData[1] = &Domain::fy;
  fieldData[2] = &Domain::fz;

  Comm& comm = *this;
  Domain&  dom  = m_dom;
  CommSBN(dom, comm, 3, fieldData);
}


void Comm::Recv_MonoQ()
{
  Comm& comm = *this;
  Domain&  dom  = m_dom;

  CommRecv(dom, comm, MSG_MONOQ, 3,
	   dom.sizeX(), dom.sizeY(), dom.sizeZ(),
	   true, true);
}


void Comm::Send_MonoQ()
{
  Comm& comm = *this;
  Domain&  dom  = m_dom;
  Domain_member fieldData[3];

  // Transfer veloctiy gradients in the first order elements
  // problem->commElements->Transfer(CommElements::monoQ);
  fieldData[0] = &Domain::delv_xi;
  fieldData[1] = &Domain::delv_eta;
  fieldData[2] = &Domain::delv_zeta;

  CommSend(dom, comm, MSG_MONOQ, 3, fieldData,
	   dom.sizeX(), dom.sizeY(), dom.sizeZ(),
	   true, true);
}

void Comm::Sync_MonoQ()
{
  Comm& comm = *this;
  Domain&  dom  = m_dom;

  CommMonoQ(dom,comm);
}

double Comm::wtime()
{
  return MPI_Wtime();
}

template<>
double Comm::allreduce_min<double>(double val)
{
  double res;
  MPI_Allreduce(&val, &res, 1, MPI_DOUBLE, MPI_MIN,
		MPI_COMM_WORLD);
  return res;
}

template<>
double Comm::reduce_max<double>(double val)
{
  double res;
  MPI_Reduce(&val, &res, 1, MPI_DOUBLE, MPI_MAX, 0,
	     MPI_COMM_WORLD);
  return res;
}
