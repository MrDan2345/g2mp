{$mode objfpc}
{.$define G2Threading}
{.$define G2Output}

{$if not defined(G2Custom_RenderMode)}
  {.$define G2RM_FF}
  {$define G2RM_SM2}
{$endif}

{$if not defined(G2Custom_CPU)}
  {$if defined(CPUI386) or defined(CPU386)}
    {$define G2Cpu386}
    {$asmmode intel}
  {$endif}
{$endif}

{$if not defined(G2Custom_Target)}
  {$if defined(MSWINDOWS)}
    {$define G2Target_Windows}
  {$elseif defined(LINUX)}
    {$ifdef CPUARM}
      {$define G2Target_Android}
    {$else}
      {$define G2Target_Linux}
    {$endif}
  {$elseif defined(DARWIN)}
    {$if defined(iPHONESIM) or defined(CPUARM)}
      {$define G2Target_iOS}
      {$modeswitch objectivec1}
    {$else}
      {$define G2Target_OSX}
    {$endif}
  {$endif}
{$endif}

{$if not defined(G2Custom_Gfx)}
  {$if defined(G2Target_Windows)}
    {$define G2Gfx_D3D9}
    {.$define G2Gfx_OGL}
  {$elseif defined(G2Target_Android)}
    {$define G2Gfx_GLES}
  {$elseif defined(G2Target_iOS)}
    {$define G2Gfx_GLES}
  {$else}
    {$define G2Gfx_OGL}
  {$endif}
{$endif}

{$if not defined(G2Custom_Snd)}
  {$if defined(G2Target_Windows)}
    {$define G2Snd_DS}
    {.$define G2Snd_OAL}
  {$elseif defined(G2Target_Android)}
    {$define G2Snd_OAL}
  {$elseif defined(G2Target_iOS)}
    {$define G2Snd_OAL}
  {$else}
    {$define G2Snd_OAL}
  {$endif}
{$endif}

//no threaded opengl renderer
{$ifdef G2Gfx_OGL}
  {$undef G2Threading}
{$endif}

{$inline on}
