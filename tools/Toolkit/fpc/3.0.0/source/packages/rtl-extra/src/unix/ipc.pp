{
    This file is part of the Free Pascal run time library.
    Copyright (c) 1999-2004 by the Free Pascal development team

    This file implements IPC calls calls for Linu/FreeBSD

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

unit ipc;

interface

Uses
{$ifdef FPC_USE_LIBCX}
  initc,
{$endif}
  BaseUnix,UnixType;

{$i osdefs.inc}       { Compile time defines }

{ ----------------------------------------------------------------------
  General IPC stuff
  ----------------------------------------------------------------------}

//Var
//  IPCError : longint;

{$packrecords c}

Type

   {$IFDEF FreeBSD}
   TKey   = clong;
{$ELSE}
   TKey   = cint;
{$ENDIF}
   key_t  = TKey;

Const
  { IPC flags for get calls }

{$if defined(FreeBSD) or defined(NetBSD) or defined(OpenBSD) or defined(dragonfly)}  // BSD_VISIBLE
  IPC_R      =  4 shl 6;
  IPC_W      =  2 shl 6;
  IPC_M      =  2 shl 12;
{$endif}

{$ifdef Darwin}
  IPC_R      =  4 shl 6;
  IPC_W      =  2 shl 6;
  IPC_M      =  1 shl 12;
{$endif}

{$ifdef aix}
  IPC_R      =  4 shl 6;
  IPC_W      =  2 shl 6;
  { no IPC_M }
{$endif}

{$ifdef Solaris}
  IPC_ALLOC  =  1 shl 15;
{$endif}

{$ifndef aix}
  IPC_CREAT  =  1 shl 9;  { create if key is non-existent }
{$else aix}
  IPC_CREAT  =  2 shl 12;
{$endif aix}
  IPC_EXCL   =  2 shl 9;  { fail if key exists }
  IPC_NOWAIT =  4 shl 9;  { return error on wait }

{$if defined(FreeBSD) or defined(Darwin) or defined(Solaris) or defined(Linux) or defined(OpenBSD) or defined (dragonfly)}
  IPC_PRIVATE = TKey(0);
{$elseif defined(aix)}
  IPC_PRIVATE = TKey(-1)
{$endif}

  { Actions for ctl calls }
{$ifdef Solaris}
  IPC_RMID = 10;    { remove identifier }
  IPC_SET  = 11;    { set ipc_perm options }
  IPC_STAT = 12;    { get ipc_perm options }
{$else}
  IPC_RMID = 0;     { remove resource }
{$ifndef aix}
  IPC_SET  = 1;     { set ipc_perm options }
  IPC_STAT = 2;     { get ipc_perm options }
{$else aix}
  IPC_SET  = 101;     { set ipc_perm options }
  IPC_STAT = 102;     { get ipc_perm options }
{$endif aix}
{$ifndef Darwin}
  IPC_INFO = 3;     { see ipcs }
{$endif}
{$endif}

type
  PIPC_Perm = ^TIPC_Perm;
{$if defined(Solaris)}
  TIPC_Perm = record
       uid   : uid_t;  { owner's user id }
       gid   : gid_t;  { owner's group id }
       cuid  : uid_t;  { creator's user id }
       cgid  : gid_t;  { creator's group id }
       mode  : mode_t; { access mode (r/w permission) }
       seq   : uint_t; { slot usage sequence number }
       key   : key_t;  { user specified msg/sem/shm key }
  {$ifndef cpu64}
       pad   : array [0..3] of cint;
  {$endif}
  End;
{$elseif defined(darwin) }
{$packrecords 4}
{ This is also the strcut for FreeBSD up to version 7
  renamed ipc_perm_old in /usr/include/sys/ipc.h in version 8 and after }
  TIPC_Perm = record
        cuid  : cushort;  { creator user id }
        cgid  : cushort;  { creator group id }
        uid   : cushort;  { user id }
        gid   : cushort;  { group id }
        mode  : cushort;  { r/w permission }
        seq   : cushort;  { sequence # (to generate unique msg/sem/shm id) }
        key   : key_t;    { user specified msg/sem/shm key }
  End;
{$packrecords c}
{$elseif defined(NetBSD) or defined(OpenBSD) or defined(FreeBSD) or defined(dragonfly)}
  TIPC_Perm = record
        cuid  : uid_t;  { creator user id }
        cgid  : gid_t;  { creator group id }
        uid   : uid_t;  { user id }
        gid   : gid_t;  { group id }
        mode  : mode_t;  { r/w permission }
        seq   : cushort;  { sequence # (to generate unique msg/sem/shm id) }
        key   : key_t;    { user specified msg/sem/shm key }
  End;
{$elseif defined(aix)}
  TIPC_Perm = record
       uid     : uid_t;
       git     : gid_t;
       cuid    : uid_t;
       cgit    : git_t;
       mode    : mode_t;
       seq     : cushort;
       key     : key_t;
  end;
{$else } // linux

{$ifdef cpu32}
  {$ifndef linux_ipc64}
    {$define linux_ipc32}
  {$endif}
{$endif}

{$if not defined(linux_ipc32) and not defined(FPC_USE_LIBC)}
  TIPC_Perm = record
        key   : TKey;
        uid   : kernel_uid_t;
        gid   : kernel_gid_t;
        cuid  : kernel_uid_t;
        cgid  : kernel_gid_t;
        mode  : kernel_mode_t;
{$if sizeof(kernel_mode_t) < 4}
        __pad1    : array[1..4-sizeof(mode_t)];
{$endif}
{$ifdef cpupowerpc}
        seq       : cuint;
{$else}
        seq       : cushort;
{$endif}
        __pad2    : cushort;
        __unused1 : culong;
        __unused2 : culong;
  End;
{$else not(linux_ipc32) and not(FPC_USE_LIBC)}
  TIPC_Perm = record
        key   : TKey;
        uid   : kernel_uid_t;
        gid   : kernel_gid_t;
        cuid  : kernel_uid_t;
        cgid  : kernel_gid_t;
        mode  : kernel_mode_t;
        seq   : cushort;
  End;
{$endif not(linux_ipc32) and not(FPC_USE_LIBC)}
{$endif}


{ Function to generate a IPC key. }
Function ftok (Path : pchar;  ID : cint) : TKey; {$ifdef FPC_USE_LIBC} cdecl; external clib name 'ftok'; {$endif}

{ ----------------------------------------------------------------------
  Sys V Shared memory stuff
  ----------------------------------------------------------------------}

Type
  PShmid_DS = ^TShmid_ds;

{$if defined(FreeBSD) or defined(OpenBSD) or defined (NetBSD) or defined(dragonfly)}
  TShmid_ds = record
    shm_perm  : TIPC_Perm;
    shm_segsz : cint;
    shm_lpid  : pid_t;
    shm_cpid  : pid_t;
    shm_nattch : cshort;
    shm_atime : time_t;
    shm_dtime : time_t;
    shm_ctime : time_t;
    shm_internal : pointer;
  end;
{$endif}

{$ifdef Solaris}
  shmatt_t = culong;

  TShmid_ds = record
    shm_perm     : TIPC_Perm; // operation permission struct
    shm_segsz    : size_t;    // size of segment in bytes
    shm_flags    : uintptr_t; // if 1 the shm_gransize is valid
    shm_lkcnt    : cushort;   // number of times it is being locked
    shm_lpid     : pid_t;     // pid of last shmop
    shm_cpid     : pid_t;     // pid of creator
    shm_nattch   : shmatt_t;  // number of attaches
    shm_cnattch  : culong;    // number of ISM attaches
{$ifdef cpu64}
    shm_atime    : time_t;    // last shmat time
    shm_dtime    : time_t;    // last shmdt time
    shm_ctime    : time_t;    // last change time
    shm_amp      : pointer;   // unused
    shm_gransize : cuint64;   // granule size
    shm_allocated: cuint64;   // mem allocated, for OSM
    shm_pad4     : cint64;    // reserve area
{$else}
    shm_atime    : time_t;    // last shmat time
    shm_pad1     : cint32;    // reserved for time_t expansion
    shm_dtime    : time_t;    // last shmdt time
    shm_pad2     : cint32;    // reserved for time_t expansion
    shm_ctime    : time_t;    // last change time
    shm_amp      : pointer;   // unused
    shm_gransize : cuint64;   // granule size
    shm_allocated: cuint64;   // mem allocated, for OSM
{$endif}
  end;
{$endif}

{$ifdef Darwin}
{$packrecords 4}
  TShmid_ds = record
    shm_perm  : TIPC_Perm;
    shm_segsz : size_t;
    shm_lpid  : pid_t;
    shm_cpid  : pid_t;
    shm_nattch : cushort; // typedef unsigned short shmatt_t
    shm_atime : time_t;
    shm_dtime : time_t;
    shm_ctime : time_t;
    shm_internal : pointer;
  end;
{$packrecords c}
{$endif}

{$if defined(Linux)}
{$ifdef cpux86_64}
  TShmid_ds = record
    shm_perm  : TIPC_Perm;
    shm_segsz : size_t;
    shm_atime : time_t;
    shm_dtime : time_t;
    shm_ctime : time_t;
    shm_cpid  : pid_t;
    shm_lpid  : pid_t;
    shm_nattch : culong;
    __unused4 : culong;
    __unused5 : culong;
  end;
{$else cpux86_64}
  TShmid_ds = record
    shm_perm  : TIPC_Perm;
    shm_segsz : cint;
    shm_atime : time_t;
    shm_dtime : time_t;
    shm_ctime : time_t;
    shm_cpid  : ipc_pid_t;
    shm_lpid  : ipc_pid_t;
    shm_nattch : word;
    shm_npages : word;
    shm_pages  : pointer;
    attaches   : pointer;
  end;
{$endif cpux86_64}
{$endif}

{$ifdef aix}
  shmatt_t = {$ifdef cpu64}culong{$else}cushort{$endif};
  TShmid_ds = record
    shm_perm      : TIPC_Perm;
    shm_segsz     : size_t;
    shm_lpid      : pid_t;
    shm_cpid      : pid_t;
    shm_nattch    : shmatt_t;
    shm_cnattch   : shmatt_t;
    shm_atime     : time_t;
    shm_dtime     : time_t;
    shm_ctime     : time_t;
    shm_handle    : {$ifdef cpu64}cuint{$else}culong{$endif};
    shm_extshm    : cint;
    shm_pagesize  : cint64;
    shm_lba       : cuint64;
    shm_reserved0 : cint64;
    shm_reserved1 : cint64;
  end;
{$endif aix}

  const
{$if defined(Linux) or defined(Solaris)}
     SHM_R      = 4 shl 6;
     SHM_W      = 2 shl 6;
{$else}
     SHM_R      = IPC_R;
     SHM_W      = IPC_W;
{$endif}

     SHM_RDONLY = 1 shl 12;
     SHM_RND    = 2 shl 12;
{$if defined(Linux)}
     SHM_REMAP  = 4 shl 12;
{$endif}
{$ifdef Darwin}
     SHMLBA     = 4096;
{$endif}
{$ifdef aix}
     SHM_PIN    = 4 shl 9;
     SHM_LGPAGE = 2 shl 30; { only available with SHM_PIN }
{$endif}

{$if defined(Solaris)}
     SHM_SHARE_MMU = 4 shl 12;
     SHM_PAGEABLE  = 1 shl 15;

     // Shared memory control operations
     SHM_LOCK   = 3;
     SHM_UNLOCK = 4;

     // Shared memory advice commands
     SHM_ADV_GET = 0;  // get advice
     SHM_ADV_SET = 1;  // set advice

     // Shared memory advice values
     SHM_ACCESS_DEFAULT   = 0;  // default access
     SHM_ACCESS_LWP       = 1;  // next thread will access heavily
     SHM_ACCESS_MANY      = 2;  // many threads will access heavily
     SHM_ACCESS_MANY_PSET = 3;  // many threads in pset will access heavily
{$elseif defined(aix)}
     SHM_SIZE      = 6;
     SHM_PAGESIZE  = 200;
     SHM_LOCK      = 201;
     SHM_UNLOCK    = 202;
     SHM_GETLBA    = 203;
{$else}
     SHM_LOCK   = 11;
     SHM_UNLOCK = 12;
{$endif}

{$ifdef FreeBSD}        // ipcs shmctl commands
     SHM_STAT   = 13;
     SHM_INFO   = 14;
{$endif}

type            // the shm*info kind is "kernel" only.
  PSHMinfo = ^TSHMinfo;
{$ifndef aix}
  TSHMinfo = record             // comment under FreeBSD/Darwin/Solaris: do we really need this?
    shmmax : cint;
    shmmin : cint;
    shmmni : cint;
    shmseg : cint;
    shmall : cint;
  end;
{$else not aix }
  TSHMinfo = record
    shmmax : culonglong;
    shmmin : cint;
    shmmni : cint;
  end;
{$endif not aix}

{$if defined(FreeBSD) or defined(OpenBSD) or defined(Linux)}
  PSHM_info = ^TSHM_info;
  TSHM_info = record
    used_ids : cint;
    shm_tot,
    shm_rss,
    shm_swp,
    swap_attempts,
    swap_successes : culong;
  end;
{$endif}

Function shmget(key: Tkey; size:size_t; flag:cint):cint; {$ifdef FPC_USE_LIBC} cdecl; external clib name 'shmget'; {$endif}
Function shmat (shmid:cint; shmaddr:pointer; shmflg:cint):pointer; {$ifdef FPC_USE_LIBC} cdecl; external clib name 'shmat'; {$endif}
Function shmdt (shmaddr:pointer):cint; {$ifdef FPC_USE_LIBC} cdecl; external clib name 'shmdt'; {$endif}
Function shmctl(shmid:cint; cmd:cint; buf: pshmid_ds): cint; {$ifdef FPC_USE_LIBC} cdecl; external clib name 'shmctl'; {$endif}

{ ----------------------------------------------------------------------
  Message queue stuff
  ----------------------------------------------------------------------}

const
  MSG_NOERROR = 1 shl 12;

{$if defined(Solaris)}
  MSG_R = 4 shl 6;      // read permission
  MSG_W = 2 shl 6;      // write permission

  MSG_RWAIT = 1 shl 9;  // a reader is waiting for a message
  MSG_WWAIT = 2 shl 9;  // a writer is waiting to send
{$endif}

{$if defined(Linux)}
  MSG_EXCEPT  = 2 shl 12;

  MSGMNI = 128;
  MSGMAX = 4056;
  MSGMNB = 16384;
{$endif}

type
  msglen_t = culong;
{$ifndef aix}
  msgqnum_t= culong;
{$else not aix}
  msgqnum_t= cuint;
{$endif not aix}

{$ifdef Darwin}
  user_msglen_t = culonglong;
  user_msgqnum_t= culonglong;
{$endif}

{$ifdef aix}
  TMsg_Hdr = record
    mtime : time_t;
    muid  : uid_t;
    mgid  : git_t;
    mpid  : pid_t;
    mtype : clong;
  end;
{$endif aix}

  PMSG = ^TMSG;
  TMSG = record
{$if not defined(FreeBSD) and not defined(Solaris)}                       // opaque in FreeBSD and Solaris
   {$if defined(Darwin)}
    msg_next  : PMSG;
    msg_type  : clong;
    msg_ts    : cushort;
    mac_label : pointer;
   {$elseif defined(aix)}
    msg_next  : PMSG;
    msg_attr  : TMsg_Hdr;
    msg_ts    : cuint;
    msg_spot  : pchar;
   {$else}
    msg_next  : PMSG;
    msg_type  : Longint;
    msg_spot  : PChar;
    msg_stime : Longint;
    msg_ts    : Integer;
   {$endif}
{$endif}
  end;

type

{$if defined(Solaris)}
 PMSQid_ds = ^TMSQid_ds;
  TMSQid_ds = record
    msg_perm   : TIPC_perm;
    msg_first  : PMsg;
    msg_last   : PMsg;
    msg_cbytes : msglen_t;
    msg_qnum   : msgqnum_t;
    msg_qbytes : msglen_t;
    msg_lspid  : pid_t;
    msg_lrpid  : pid_t;
{$ifdef cpu64}
    msg_stime  : time_t;
    msg_rtime  : time_t;
    msg_ctime  : time_t;
{$else}
    msg_stime  : time_t;
    msg_pad1   : cint32;
    msg_rtime  : time_t;
    msg_pad2   : cint32;
    msg_ctime  : time_t;
    msg_pad3   : cint32;
{$endif}
    msg_cv     : cshort;
    msg_qnum_cv: cshort;
    msg_pad4   : array [0..2] of clong;
  end;
{$elseif defined(Linux)}
  PMSQid_ds = ^TMSQid_ds;
  TMSQid_ds = record
    msg_perm   : TIPC_perm;
    msg_first  : PMsg;
    msg_last   : PMsg;
    msg_stime  : time_t;
    msg_rtime  : time_t;
    msg_ctime  : time_t;
    msg_cbytes : word;
    msg_qnum   : word;
    msg_qbytes : word;
    msg_lspid  : ipc_pid_t;
    msg_lrpid  : ipc_pid_t;
  end;
{$else}
  {$if defined(Darwin)}
{$packrecords 4}
     PMSQid_ds = ^TMSQid_ds;
     TMSQid_ds = record
       msg_perm   : TIPC_perm;
       msg_first  : cint32;
       msg_last   : cint32;
       msg_cbytes : msglen_t;
       msg_qnum   : msgqnum_t;
       msg_qbytes : msglen_t;
       msg_lspid  : pid_t;
       msg_lrpid  : pid_t;
       msg_stime  : time_t;
       msg_pad1   : cint32;
       msg_rtime  : time_t;
       msg_pad2   : cint32;
       msg_ctime  : time_t;
       msg_pad3   : cint32;
       msg_pad4   : array [0..3] of cint32;
     end;
{$packrecords c}
  {$elseif defined(aix)}
      PMSQid_ds = ^TMSQid_ds;
      TMSQid_ds = record
        msg_perm   : TIPC_perm;
       {$ifdef cpu64}
        msg_first  : cuint;
        msg_last   : cuint;
       {$else cpu64}
        msg_first  : PMsg;
        msg_last   : PMsg;
       {$endif}
        msg_cbytes : cuint;
        msg_qnum   : msgqnum_t;
        msg_qbytes : msglen_t;
        msg_lspid  : pid_t;
        msg_lrpid  : pid_t;
        msg_stime  : time_t;
        msg_rtime  : time_t;
        msg_ctime  : time_t;
        msg_rwait  : cint;
        msg_wwait  : cint;
        msg_reqevents : cushort;
      end;
  {$else}
     PMSQid_ds = ^TMSQid_ds;
     TMSQid_ds = record
       msg_perm   : TIPC_perm;
       msg_first  : PMsg;
       msg_last   : PMsg;
       msg_cbytes : msglen_t;
       msg_qnum   : msgqnum_t;
       msg_qbytes : msglen_t;
       msg_lspid  : pid_t;
       msg_lrpid  : pid_t;
       msg_stime  : time_t;
       msg_pad1   : clong;
       msg_rtime  : time_t;
       msg_pad2   : clong;
       msg_ctime  : time_t;
       msg_pad3   : clong;
       msg_pad4   : array [0..3] of clong;
     end;
  {$endif}
{$endif}

  PMSGbuf = ^TMSGbuf;
  TMSGbuf = record              // called mymsg on freebsd and SVID manual
    mtype : clong;
    mtext : array[0..0] of char;
  end;

{$if defined(linux)}
  PMSGinfo = ^TMSGinfo;
  TMSGinfo = record
    msgpool : cint;
    msgmap  : cint;
    msgmax  : cint;
    msgmnb  : cint;
    msgmni  : cint;
    msgssz  : cint;
    msgtql  : cint;
    msgseg  : cushort;
  end;
{$elseif defined(aix)}
  PMSGinfo = ^TMSGinfo;
  TMSGinfo = record
    msgmax,
    msgmnb,
    msgmni,
    msgmnm  : cint;
  end;
{$else}
  PMSGinfo = ^TMSGinfo;
  TMSGinfo = record
    msgmax,
    msgmni,
    msgmnb,
    msgtql,
    msgssz,
    msgseg  : cint;
  end;
{$endif}

Function msgget(key: TKey; msgflg:cint):cint; {$ifdef FPC_USE_LIBC} cdecl; external clib name 'msgget'; {$endif}
Function msgsnd(msqid:cint; msgp: PMSGBuf; msgsz: size_t; msgflg:cint): cint; {$ifdef FPC_USE_LIBC} cdecl; external clib name 'msgsnd'; {$endif}
Function msgrcv(msqid:cint; msgp: PMSGBuf; msgsz: size_t; msgtyp:clong; msgflg:cint): {$if defined(Darwin) or defined(aix) or defined(Solaris)}ssize_t;{$else}cint;{$endif} {$ifdef FPC_USE_LIBC} cdecl; external clib name 'msgrcv'; {$endif}
Function msgctl(msqid:cint; cmd: cint; buf: PMSQid_ds): cint; {$ifdef FPC_USE_LIBC} cdecl; external clib name 'msgctl'; {$endif}

{ ----------------------------------------------------------------------
  Semaphores stuff
  ----------------------------------------------------------------------}

const
{$if defined(Linux)}                  // renamed to many name clashes
  SEM_UNDO = $1000;
  SEM_GETPID = 11;
  SEM_GETVAL = 12;
  SEM_GETALL = 13;
  SEM_GETNCNT = 14;
  SEM_GETZCNT = 15;
  SEM_SETVAL = 16;
  SEM_SETALL = 17;

  SEM_SEMMNI = 128;
  SEM_SEMMSL = 32;
  SEM_SEMMNS = (SEM_SEMMNI * SEM_SEMMSL);
  SEM_SEMOPM = 32;
  SEM_SEMVMX = 32767;
{$else}
  SEM_UNDO = 1 shl 12;
{$if not defined(Solaris)}
  MAX_SOPS = 5;
{$endif}

{$if not defined(aix) and not defined(darwin)}
  SEM_GETNCNT = 3;   { Return the value of sempid (READ)  }
  SEM_GETPID  = 4;   { Return the value of semval (READ)  }
  SEM_GETVAL  = 5;   { Return semvals into arg.array (READ)  }
  SEM_GETALL  = 6;   { Return the value of semzcnt (READ)  }
  SEM_GETZCNT = 7;   { Set the value of semval to arg.val (ALTER)  }
  SEM_SETVAL  = 8;   { Set semvals from arg.array (ALTER)  }
  SEM_SETALL  = 9;
{$endif}

  { Permissions  }

  SEM_A = 2 shl 6;  { alter permission  }
  SEM_R = 4 shl 6;  { read permission  }

{$endif}

type
{$if defined(Linux)}

{$ifndef linux_ipc32}
 PSEMid_ds = ^TSEMid_ds;
 TSEMid_ds = record
   sem_perm  : tipc_perm;
   sem_otime : time_t;   // kernel
   unused1   : culong;
   sem_ctime : time_t;
   unused2   : culong;
   sem_nsems : culong;
   unused3   : culong;
   unused4   : culong;
  end;
{$else not linux_ipc32}
  PSEMid_ds = ^TSEMid_ds;
  TSEMid_ds = record
    sem_perm : tipc_perm;
    sem_otime : time_t;   // kernel
    sem_ctime : time_t;
    sem_base         : pointer;
    sem_pending      : pointer;
    sem_pending_last : pointer;
    undo             : pointer;
    sem_nsems : cushort;
  end;
{$endif not linux_ipc32}
{$else Linux}
   {$if defined(Darwin)}
     PSEM = ^TSEM;
     TSEM = record
       semval  : cushort;
       sempid  : pid_t;
       semncnt : cushort;
       semzcnt : cushort;
     end;
{$packrecords 4}
     PSEMid_ds = ^TSEMid_ds;
     TSEMid_ds = record
             sem_perm : tipc_perm;
             sem_base : cint32;
             sem_nsems : cushort;
             sem_otime : time_t;
             sem_pad1 : cint32;
             sem_ctime : time_t;
             sem_pad2 : cint32;
             sem_pad3 : array[0..3] of cint32;
          end;
{$packrecords c}
   {$elseif defined(aix)}
     tid_t = {$ifdef cpu64}clong{$else}cint{$endif};
     PSEM = ^TSEM;
     TSEM = record
       semval   : cushort;
       flags    : cushort;
       sempid   : pid_t;
       semncnt  : cushort;
       semzcnt  : cushort;
       semnwait : tid_t;
       semzwait : tid_t;
     end;
     PSEMid_ds = ^TSEMid_ds;
     TSEMid_ds = record
       sem_perm: tipc_perm;
      {$ifdef cpu64}
       sem_base: cuint;
      {$else}
       sem_base: PSEM;
      {$endif}
       sem_nsems: cushort;
       sem_otime: time_t;
       sem_ctime: time_t;
     end;
   {$elseif defined(Solaris)}
     PSEM = ^TSEM;
     TSEM = record end; // opague

     PSEMid_ds = ^TSEMid_ds;
     TSEMid_ds = record
        sem_perm  : tipc_perm;
        sem_base  : PSEM;
        sem_nsems : cushort;
     {$ifdef cpu64}
        sem_otime : time_t;
        sem_ctime : time_t;
     {$else}
        sem_otime : time_t;
        sem_pad1  : cint32;
        sem_ctime : time_t;
        sem_pad2  : cint32;
     {$endif}
        sem_binary: cint;
        sem_pad3  : array[0..2] of clong;
     end;
   {$else}
     PSEM = ^TSEM;
     TSEM = record end; // opaque

     PSEMid_ds = ^TSEMid_ds;
     TSEMid_ds = record
             sem_perm : tipc_perm;
             sem_base : PSEM;
             sem_nsems : cushort;
             sem_otime : time_t;
             sem_pad1 : cint;
             sem_ctime : time_t;
             sem_pad2 : cint;
             sem_pad3 : array[0..3] of cint;
          end;
    {$endif}
{$endif}

  PSEMbuf = ^TSEMbuf;
  TSEMbuf = record
    sem_num : cushort;
    sem_op  : cshort;
    sem_flg : cshort;
  end;


  PSEMinfo = ^TSEMinfo;
{$ifndef aix}
  TSEMinfo = record
    semmap : cint;
    semmni : cint;
    semmns : cint;
    semmnu : cint;
    semmsl : cint;
    semopm : cint;
    semume : cint;
    semusz : cint;
    semvmx : cint;
    semaem : cint;
  end;
{$else not aix}
  TSEMinfo = record
    semmni : cint;
    semmsl : cint;
    semopm : cint;
    semume : cint;
    semusz : cint;
    semvmx : cint;
    semaem : cint;
  end;
{$endif not aix}

{ internal mode bits}

{$ifdef FreeBSD}
Const
  SEM_ALLOC = 1 shl 9;
  SEM_DEST  = 2 shl 9;
{$endif}

Type
  PSEMun = ^TSEMun;
  TSEMun = record
   case cint of
      0 : ( val : cint );
      1 : ( buf : PSEMid_ds );
      2 : ( arr : PWord );              // ^ushort
{$if defined(linux)}
      3 : ( padbuf : PSeminfo );
      4 : ( padpad : pointer );
{$endif}
   end;

Function semget(key:Tkey; nsems:cint; semflg:cint): cint; {$ifdef FPC_USE_LIBC} cdecl; external clib name 'semget'; {$endif}
Function semop(semid:cint; sops: psembuf; nsops: cuint): cint; {$ifdef FPC_USE_LIBC} cdecl; external clib name 'semop'; {$endif}
Function semctl(semid:cint; semnum:cint; cmd:cint; var arg: tsemun): cint;
{$if defined(linux)}
Function semtimedop(semid:cint; sops: psembuf; nsops: cuint; timeOut: ptimespec): cint; {$ifdef FPC_USE_LIBC} cdecl; external name 'semtimedop'; platform; {$else} platform; {$endif}
{$endif}
{$ifdef aix}
{ only available as of AIX 6.1 }
Function semtimedop(semid:cint; sops: psembuf; nsops: size_t; timeOut: ptimespec): cint; {$ifdef FPC_USE_LIBC} cdecl; weakexternal name 'semtimedop'; platform; {$else} platform; {$endif}
{$endif}

implementation

{$ifndef FPC_USE_LIBC}
uses Syscall;
{$endif ndef FPC_USE_LIBC}

{$ifndef FPC_USE_LIBC}
 {$if defined(Linux)}
  {$if defined(cpux86_64) or defined(NO_SYSCALL_IPC)}
    {$i ipcsys.inc}
  {$else}
    {$i ipccall.inc}
  {$endif}
 {$endif}
 {$ifdef BSD}
   {$i ipcbsd.inc}
 {$endif}
{$else ndef FPC_USE_LIBC}
Function real_semctl(semid:cint; semnum:cint; cmd:cint): cint; {$ifdef FPC_USE_LIBC} cdecl; varargs; external clib name 'semctl'; {$endif}

Function semctl(semid:cint; semnum:cint; cmd:cint; var arg: tsemun): cint;
  begin
    semctl := real_semctl(semid,semnum,cmd,pointer(arg));
  end;
{$endif}


end.
