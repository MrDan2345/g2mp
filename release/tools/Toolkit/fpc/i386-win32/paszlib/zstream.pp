unit zstream;

{**********************************************************************
    This file is part of the Free Pascal free component library.

    Copyright (c) 2007 by Daniel Mantione
      member of the Free Pascal development team

    Implements a Tstream descendents that allow you to read and write
    compressed data according to the Deflate algorithm described in
    RFC1951.

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

{$mode objfpc}

{***************************************************************************}
                                    interface
{***************************************************************************}

uses    classes,zbase,gzio;

type
        Tcompressionlevel=(
          clnone,                     {Do not use compression, just copy data.}
          clfastest,                  {Use fast (but less) compression.}
          cldefault,                  {Use default compression}
          clmax                       {Use maximum compression}
        );

        Tgzopenmode=(
          gzopenread,                 {Open file for reading.}
          gzopenwrite                 {Open file for writing.}
        );

        Tcustomzlibstream=class(Townerstream)
        protected
          Fstream:z_stream;
          Fbuffer:pointer;
          Fonprogress:Tnotifyevent;
          procedure progress(sender:Tobject);
          property onprogress:Tnotifyevent read Fonprogress write Fonprogress;
        public
          constructor create(stream:Tstream);
          destructor destroy;override;
        end;

        Tcompressionstream=class(Tcustomzlibstream)
        protected
          raw_written,compressed_written:longint;
        public
          constructor create(level:Tcompressionlevel;
                             dest:Tstream;
                             Askipheader:boolean=false);
          destructor destroy;override;
          function write(const buffer;count:longint):longint;override;
          procedure flush;
          function get_compressionrate:single;
          property OnProgress;
        end;

        Tdecompressionstream=class(Tcustomzlibstream)
        protected
          raw_read,compressed_read:longint;
          skipheader:boolean;
          procedure reset;
          function GetPosition() : Int64; override;
        public
          constructor create(Asource:Tstream;Askipheader:boolean=false);
          destructor destroy;override;
          function read(var buffer;count:longint):longint;override;
          function seek(offset:longint;origin:word):longint;override;
          function get_compressionrate:single;
          property OnProgress;
        end;

        TGZFileStream = Class(TStream)
        protected
          Fgzfile:gzfile;
          Ffilemode:Tgzopenmode;
        public
          constructor create(filename:ansistring;filemode:Tgzopenmode);
          function read(var buffer;count:longint):longint;override;
          function write(const buffer;count:longint):longint;override;
          function seek(offset:longint;origin:word):longint;override;
          destructor destroy;override;
        end;

        Ezliberror=class(Estreamerror)
        end;

        Egzfileerror=class(Ezliberror)
        end;

        Ecompressionerror=class(Ezliberror)
        end;

        Edecompressionerror=class(Ezliberror)
        end;

{***************************************************************************}
                                 implementation
{***************************************************************************}

uses    zdeflate,zinflate;

const   bufsize=16384;     {Size of the buffer used for temporarily storing
                            data from the child stream.}

resourcestring Sgz_open_error='Could not open gzip compressed file %s.';
               Sgz_read_only='Gzip compressed file was opened for reading.';
               Sgz_write_only='Gzip compressed file was opened for writing.';
               Sseek_failed='Seek in deflate compressed stream failed.';

constructor Tcustomzlibstream.create(stream:Tstream);

begin
  assert(stream<>nil);
  inherited create(stream);
  getmem(Fbuffer,bufsize);
end;

procedure Tcustomzlibstream.progress(sender:Tobject);

begin
  if Fonprogress<>nil then
    Fonprogress(sender);
end;

destructor Tcustomzlibstream.destroy;

begin
  freemem(Fbuffer);
  inherited destroy;
end;

{***************************************************************************}

constructor Tcompressionstream.create(level:Tcompressionlevel;
                                      dest:Tstream;
                                      Askipheader:boolean=false);

var err,l:smallint;

begin
  inherited create(dest);
  Fstream.next_out:=Fbuffer;
  Fstream.avail_out:=bufsize;

  case level of
    clnone:
      l:=Z_NO_COMPRESSION;
    clfastest:
      l:=Z_BEST_SPEED;
    cldefault:
      l:=Z_DEFAULT_COMPRESSION;
    clmax:
      l:=Z_BEST_COMPRESSION;
  end;

  if Askipheader then
    err:=deflateInit2(Fstream,l,Z_DEFLATED,-MAX_WBITS,DEF_MEM_LEVEL,0)
  else
    err:=deflateInit(Fstream,l);
  if err<>Z_OK then
    raise Ecompressionerror.create(zerror(err));
end;

function Tcompressionstream.write(const buffer;count:longint):longint;

var err:smallint;
    lastavail,
    written:longint;

begin
  Fstream.next_in:=@buffer;
  Fstream.avail_in:=count;
  lastavail:=count;
  while Fstream.avail_in<>0 do
    begin
      if Fstream.avail_out=0 then
        begin
          { Flush the buffer to the stream and update progress }
          written:=source.write(Fbuffer^,bufsize);
          inc(compressed_written,written);
          inc(raw_written,lastavail-Fstream.avail_in);
          lastavail:=Fstream.avail_in;
          progress(self);
          { reset output buffer }
          Fstream.next_out:=Fbuffer;
          Fstream.avail_out:=bufsize;
        end;
      err:=deflate(Fstream,Z_NO_FLUSH);
      if err<>Z_OK then
        raise Ecompressionerror.create(zerror(err));
    end;
  inc(raw_written,lastavail-Fstream.avail_in);
  write:=count;
end;

function Tcompressionstream.get_compressionrate:single;

begin
  get_compressionrate:=100*compressed_written/raw_written;
end;


procedure Tcompressionstream.flush;

var err:smallint;
    written:longint;

begin
  {Compress remaining data still in internal zlib data buffers.}
  repeat
    if Fstream.avail_out=0 then
      begin
        { Flush the buffer to the stream and update progress }
        written:=source.write(Fbuffer^,bufsize);
        inc(compressed_written,written);
        progress(self);
        { reset output buffer }
        Fstream.next_out:=Fbuffer;
        Fstream.avail_out:=bufsize;
      end;
    err:=deflate(Fstream,Z_FINISH);
    if err=Z_STREAM_END then
      break;
    if (err<>Z_OK) then
      raise Ecompressionerror.create(zerror(err));
  until false;
  if Fstream.avail_out<bufsize then
    begin
      source.writebuffer(FBuffer^,bufsize-Fstream.avail_out);
      inc(compressed_written,bufsize-Fstream.avail_out);
      progress(self);
    end;
end;


destructor Tcompressionstream.destroy;

begin
  try
    Flush;
  finally
    deflateEnd(Fstream);
    inherited destroy;
  end;
end;

{***************************************************************************}

constructor Tdecompressionstream.create(Asource:Tstream;Askipheader:boolean=false);

var err:smallint;

begin
  inherited create(Asource);

  skipheader:=Askipheader;
  if Askipheader then
    err:=inflateInit2(Fstream,-MAX_WBITS)
  else
    err:=inflateInit(Fstream);
  if err<>Z_OK then
    raise Ecompressionerror.create(zerror(err));
end;

function Tdecompressionstream.read(var buffer;count:longint):longint;

var err:smallint;
    lastavail:longint;

begin
  Fstream.next_out:=@buffer;
  Fstream.avail_out:=count;
  lastavail:=count;
  while Fstream.avail_out<>0 do
    begin
      if Fstream.avail_in=0 then
        begin
          {Refill the buffer.}
          Fstream.next_in:=Fbuffer;
          Fstream.avail_in:=source.read(Fbuffer^,bufsize);
          inc(compressed_read,Fstream.avail_in);
          inc(raw_read,lastavail-Fstream.avail_out);
          lastavail:=Fstream.avail_out;
          progress(self);
        end;
      err:=inflate(Fstream,Z_NO_FLUSH);
      if err=Z_STREAM_END then
        break;
      if err<>Z_OK then
        raise Edecompressionerror.create(zerror(err));
    end;
  if err=Z_STREAM_END then
    dec(compressed_read,Fstream.avail_in);
  inc(raw_read,lastavail-Fstream.avail_out);
  read:=count-Fstream.avail_out;
end;

procedure Tdecompressionstream.reset;

var err:smallint;

begin
  source.seek(-compressed_read,sofromcurrent);
  raw_read:=0;
  compressed_read:=0;
  inflateEnd(Fstream);
  if skipheader then
    err:=inflateInit2(Fstream,-MAX_WBITS)
  else
    err:=inflateInit(Fstream);
  if err<>Z_OK then
    raise Edecompressionerror.create(zerror(err));
end;

function Tdecompressionstream.GetPosition() : Int64; 
begin
  GetPosition := raw_read;
end;

function Tdecompressionstream.seek(offset:longint;origin:word):longint;

var c:longint;

begin
  if (origin=sofrombeginning) or
     ((origin=sofromcurrent) and (offset+raw_read>=0)) then
    begin
      if origin = sofromcurrent then 
        seek := raw_read + offset
      else
        seek := offset;
        
      if origin=sofrombeginning then
        dec(offset,raw_read);
      if offset<0 then
        begin
          inc(offset,raw_read);
          reset;
        end;
      while offset>0 do
        begin
          c:=offset;
          if c>bufsize then
            c:=bufsize;
          c:=read(Fbuffer^,c);
          dec(offset,c);
        end;
    end
  else
    raise Edecompressionerror.create(Sseek_failed);
end;

function Tdecompressionstream.get_compressionrate:single;

begin
  get_compressionrate:=100*compressed_read/raw_read;
end;


destructor Tdecompressionstream.destroy;

begin
  inflateEnd(Fstream);
  inherited destroy;
end;


{***************************************************************************}

constructor Tgzfilestream.create(filename:ansistring;filemode:Tgzopenmode);

begin
  if filemode=gzopenread then
    Fgzfile:=gzopen(filename,'rb')
  else
    Fgzfile:=gzopen(filename,'wb');
  Ffilemode:=filemode;
  if Fgzfile=nil then
    raise Egzfileerror.createfmt(Sgz_open_error,[filename]);
end;

function Tgzfilestream.read(var buffer;count:longint):longint;

begin
  if Ffilemode=gzopenwrite then
    raise Egzfileerror.create(Sgz_write_only);
  read:=gzread(Fgzfile,@buffer,count);
end;

function Tgzfilestream.write(const buffer;count:longint):longint;

begin
  if Ffilemode=gzopenread then
    raise Egzfileerror.create(Sgz_write_only);
  write:=gzwrite(Fgzfile,@buffer,count);
end;

function Tgzfilestream.seek(offset:longint;origin:word):longint;

begin
  seek:=gzseek(Fgzfile,offset,origin);
  if seek=-1 then
    raise egzfileerror.create(Sseek_failed);
end;

destructor Tgzfilestream.destroy;

begin
  gzclose(Fgzfile);
  inherited destroy;
end;

end.
