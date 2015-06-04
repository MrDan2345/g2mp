//G2PathFinder v1.0
//  Author: Dan
//  email - dan.soft.studio@gmail.com
//
//Instructions:
//
//  Globals:
//    var
//      PathFinder: TG2PathFinder;
//      Map: PG2PathMap;
//      WayPoints: TG2PathWayPoints
//
//  Initialization:
//    PathFinder := TG2PathFinder.Create;
//    Map := PathFinder.CreateMap(VarWidth, VarHeight);
//
//  Finalization:
//    PathFinder.FreeMap(Map);
//    PathFinder.Free;
//
//  Path Finding:
//    PathFinder.FindPath(
//      Map,
//      VarStartPosX, VarStartPosY,
//      VarFinishPosX, VarFinishPosY,
//      @WayPoints
//    );
//
//  Properties:
//    TG2PathFinder.Heuristic:
//      Heuristic calculation algorithm
//      phManhattan
//      phDiagonal
//      phDistance
//      phWave (no Heuristic)
//
//    TG2PathFinder.HAmp:
//      An amplifier of heuristic effect
//
//    TG2PathFinder.MoveDiag:
//      Allow the path to go through diagonally
//      located nodes.
//      Example:
//        X - wall
//        S - start
//        F - finish
//        * - waypoints
//
//        MoveDiag = true
//         __________
//        |S*        |
//        |XX*    XXX|
//        |   *   X F|
//        |    ***X* |
//        | XXXXXX*  |
//        |          |
//        |__________|
//
//        MoveDiag = false
//         __________
//        |S**       |
//        |XX*    XXX|
//        |  *    X F|
//        |***    X**|
//        |*XXXXXX** |
//        |********  |
//        |__________|
//
//    TG2PathFinder.WallBend:
//      Works in combination with MoveDiag = true
//      Example:
//
//        MoveDiag = true and WallBend = true
//         __________
//        |S**       |
//        |XX*    XXX|
//        |  *    X F|
//        |**     X *|
//        |*XXXXXX * |
//        |********  |
//        |__________|
//
//
//    TG2PathNode
//      Can be accessed through Map.Nodes[X, Y]
//      TG2PathNode.Cost
//        The cost of travelling through this node,
//        the higher the cost the less likely it is
//        that the path with go through this node,
//        an exception is the cost of 0 which means
//        the node is a solid wall
//
unit G2PathFinder;

interface

uses
  Types,
  G2Types,
  G2Utils,
  G2Math;

type
  TG2PathFinder = class;

  TG2PathHeuristic = (
    phManhattan,
    phDiagonal,
    phDistance,
    phWave
  );

  PG2PathNode = ^TG2PathNode;
  TG2PathNode = record
    X: TG2IntS32;
    Y: TG2IntS32;
    Cost: TG2IntS32;
    H: TG2IntS32;
    F: TG2IntS32;
    Parent: PG2PathNode;
    Open: Boolean;
  end;

  TG2PathWayPoint = record
    X, Y: TG2IntS32;
  end;

  PG2PathWayPoints = ^TG2PathWayPoints;
  TG2PathWayPoints = array of TG2PathWayPoint;

  PG2Path = ^TG2Path;
  TG2Path = record
    Nodes: array of PG2PathNode;
  end;

  PG2PathMap = ^TG2PathMap;
  TG2PathMap = record
    Nodes: array of array of TG2PathNode;
    CostH: TG2IntS32;
    CostV: TG2IntS32;
    CostD: TG2IntS32;
    BaseCost: TG2IntS32;
  end;

  TG2PathFinder = class
  private
    _LastPath: PG2Path;
    _HeuristicType: TG2PathHeuristic;
    _HAmp: TG2Float;
    _MoveDiag: Boolean;
    _WallBend: Boolean;
  public
    property Path: PG2Path read _LastPath write _LastPath;
    property Heuristic: TG2PathHeuristic read _HeuristicType write _HeuristicType;
    property HAmp: TG2Float read _HAmp write _HAmp;
    property MoveDiag: Boolean read _MoveDiag write _MoveDiag;
    property WallBend: Boolean read _WallBend write _WallBend;
    constructor Create;
    destructor Destroy; override;
    function CreateMap(
      const Width, Height: TG2IntS32;
      const BaseCost: TG2IntS32 = 20;
      const CostH: TG2IntS32 = 10;
      const CostV: TG2IntS32 = 10;
      const CostD: TG2IntS32 = 14
    ): PG2PathMap;
    procedure FreeMap(var Map: PG2PathMap);
    function FindPath(
      const Map: PG2PathMap;
      const StartX, StartY, FinishX, FinishY: TG2IntS32;
      const WayPoints: PG2PathWayPoints = nil
    ): PG2Path;
  end;
  
implementation

//TG2PathFinder BEGIN
constructor TG2PathFinder.Create;
begin
  inherited Create;
  New(_LastPath);
  _HeuristicType := phManhattan;
  _HAmp := 1;
  _MoveDiag := True;
  _WallBend := False;
end;

destructor TG2PathFinder.Destroy;
begin
  SetLength(_LastPath^.Nodes, 0);
  Dispose(_LastPath);
  inherited Destroy;
end;

function TG2PathFinder.CreateMap(
  const Width, Height: TG2IntS32;
  const BaseCost: TG2IntS32 = 20;
  const CostH: TG2IntS32 = 10;
  const CostV: TG2IntS32 = 10;
  const CostD: TG2IntS32 = 14
): PG2PathMap;
  var i, j: TG2IntS32;
begin
  New(Result);
  SetLength(Result^.Nodes, Width, Height);
  Result^.CostH := CostH;
  Result^.CostV := CostV;
  Result^.CostD := CostD;
  Result^.BaseCost := BaseCost;
  for j := 0 to Height - 1 do
  for i := 0 to Width - 1 do
  begin
    Result^.Nodes[i,j].X := i;
    Result^.Nodes[i,j].Y := j;
    Result^.Nodes[i,j].Cost := BaseCost;
    Result^.Nodes[i,j].H := 0;
    Result^.Nodes[i,j].F := 0;
    Result^.Nodes[i,j].Parent := nil;
    Result^.Nodes[i,j].Open := False;
  end;
end;

procedure TG2PathFinder.FreeMap(var Map: PG2PathMap);
begin
  SetLength(Map^.Nodes, 0);
  Dispose(Map);
  Map := nil;
end;

function TG2PathFinder.FindPath(
  const Map: PG2PathMap;
  const StartX, StartY, FinishX, FinishY: TG2IntS32;
  const WayPoints: PG2PathWayPoints = nil
): PG2Path;
  function GetHeuristic(const X, Y: TG2IntS32): TG2IntS32;
    var DX, DY, sMin, sMax: TG2IntS32;
  begin
    case _HeuristicType of
      phManhattan:
      Result := Abs(X - FinishX) * Map^.CostH + Abs(Y - FinishY) * Map^.CostV;
      phDiagonal:
      begin
        DX := Abs(X - FinishX);
        DY := Abs(Y - FinishY);
        sMin := G2Min(DX, DY);
        sMax := G2Max(DX, DY);
        if DX < DY then
        Result := sMin * Map^.CostD + (sMax - sMin) * Map^.CostV
        else
        Result := sMin * Map^.CostD + (sMax - sMin) * Map^.CostH;
      end;
      phDistance:
      begin
        DX := Abs(X - FinishX) * Map^.CostH;
        DY := Abs(Y - FinishY) * Map^.CostV;
        Result := Round(Sqrt((DX * DX) + (DY * DY)));
      end;
      else
      Result := 1;
    end;
    if _HAmp <> 1 then
    Result := Round(Result * _HAmp);
  end;
  var i, j: TG2IntS32;
  var CurNode: PG2PathNode;
  var TestNode: PG2PathNode;
  var MoveDir: array of TPoint;
  var MoveCosts: array[0..7] of TG2IntS32;
  var OpenNodes: TG2QuickList;
  var PathFound: Boolean;
  var PathLength: TG2IntS32;
  var NewCost: TG2IntS32;
  var NewPos: TPoint;
  var AllowNode: Boolean;
  procedure AddOpenNode(const Node: PG2PathNode);
    var l, h, dif, m: TG2IntS32;
  begin
    l := 0;
    h := OpenNodes.Count - 1;
    while l <= h do
    begin
      m := (l + h) div 2;
      dif := PG2PathNode(OpenNodes.Items[m])^.F - Node^.F;
      if dif < 0 then l := m + 1
      else h := m - 1;
    end;
    OpenNodes.Insert(l, Node);
    Node^.Open := true;
  end;
  procedure RemoveOpenNode(const Node: PG2PathNode);
  begin
    OpenNodes.Remove(Node);
    Node^.Open := False;
  end;
const
  DiagonalMoveDir: array [0..7] of TPoint = (
    (X: -1; Y: -1), (X: 0; Y: -1), (X: 1; Y: -1), (X: 1; Y: 0),
    (X: 1; Y: 1), (X: 0; Y: 1), (X: -1; Y: 1), (X: -1; Y: 0)
  );
  LinearMoveDir: array [0..3] of TPoint = (
    (X: 0; Y: -1), (X: 1; Y: 0), (X: 0; Y: 1), (X: -1; Y: 0)
  );
begin
  PathFound := False;
  CurNode := nil;
  if (Map^.Nodes[StartX, StartY].Cost = 0)
  or (Map^.Nodes[FinishX, FinishY].Cost = 0) then
  begin
    SetLength(_LastPath^.Nodes, 0);
    if WayPoints <> nil then
    SetLength(WayPoints^, 0);
    Result := _LastPath;
    Exit;
  end;
  if _MoveDiag then
  begin
    SetLength(MoveDir, 8);
    Move(DiagonalMoveDir[0], MoveDir[0], SizeOf(TPoint) * 8);
    MoveCosts[0] := Map^.CostD;
    MoveCosts[1] := Map^.CostV;
    MoveCosts[2] := Map^.CostD;
    MoveCosts[3] := Map^.CostH;
    MoveCosts[4] := Map^.CostD;
    MoveCosts[5] := Map^.CostV;
    MoveCosts[6] := Map^.CostD;
    MoveCosts[7] := Map^.CostH;
  end
  else
  begin
    SetLength(MoveDir, 4);
    Move(LinearMoveDir[0], MoveDir[0], SizeOf(TPoint) * 4);
    MoveCosts[0] := Map^.CostV;
    MoveCosts[1] := Map^.CostH;
    MoveCosts[2] := Map^.CostV;
    MoveCosts[3] := Map^.CostH;
  end;
  for j := 0 to High(Map^.Nodes[0]) do
  for i := 0 to High(Map^.Nodes) do
  begin
    Map^.Nodes[i, j].H := 0;
    Map^.Nodes[i, j].F := 0;
    Map^.Nodes[i, j].Parent := nil;
    Map^.Nodes[i, j].Open := False;
  end;
  OpenNodes.Clear;
  AddOpenNode(@Map^.Nodes[StartX, StartY]);
  Map^.Nodes[StartX, StartY].H := GetHeuristic(StartX, StartY);
  while (OpenNodes.Count > 0) and not PathFound do
  begin
    CurNode := OpenNodes.Items[0];
    if (CurNode^.X = FinishX) and (CurNode^.Y = FinishY) then
    PathFound := True
    else
    begin
      for i := 0 to High(MoveDir) do
      begin
        NewPos.X := CurNode^.X + MoveDir[i].X;
        NewPos.Y := CurNode^.Y + MoveDir[i].Y;
        if (NewPos.X < 0) or (NewPos.X > High(Map^.Nodes))
        or (NewPos.Y < 0) or (NewPos.Y > High(Map^.Nodes[0])) then
        Continue;
        TestNode := @Map^.Nodes[NewPos.X, NewPos.Y];
        if not _MoveDiag or not _WallBend then
        AllowNode := True
        else
        AllowNode := (
          Odd(i)
          or
          (
            not Odd(i)
            and
            (
              (Map^.Nodes[NewPos.X, CurNode^.Y].Cost > 0)
              and
              (Map^.Nodes[CurNode^.X, NewPos.Y].Cost > 0)
            )
          )
        );
        if (TestNode^.Cost > 0) and AllowNode then
        begin
          if (_HeuristicType <> phWave) and (TestNode^.H = 0) then
          TestNode^.H := GetHeuristic(TestNode^.X, TestNode^.Y);
          NewCost := CurNode^.F  + TestNode^.H + TestNode^.Cost + MoveCosts[i];
          if (TestNode^.F = 0) or (NewCost < TestNode^.F) then
          begin
            TestNode^.F := NewCost;
            TestNode^.Parent := CurNode;
            if not TestNode^.Open then AddOpenNode(TestNode);
          end;
        end;
      end;
    end;
    RemoveOpenNode(CurNode);
  end;
  if PathFound then
  begin
    SetLength(_LastPath^.Nodes, Length(Map^.Nodes[0]) * Length(Map^.Nodes));
    PathLength := 0;
    while CurNode <> @Map^.Nodes[StartX, StartY] do
    begin
      _LastPath^.Nodes[High(_LastPath^.Nodes) - PathLength] := CurNode;
      PathLength := PathLength + 1;
      CurNode := CurNode^.Parent;
    end;
    _LastPath^.Nodes[High(_LastPath^.Nodes) - PathLength] := CurNode;
    PathLength := PathLength + 1;
    if PathLength > 0 then
    Move(
      _LastPath^.Nodes[High(_LastPath^.Nodes) - (PathLength - 1)],
      _LastPath^.Nodes[0],
      PathLength * SizeOf(PG2PathNode)
    );
    SetLength(_LastPath^.Nodes, PathLength);
    if WayPoints <> nil then
    begin
      SetLength(WayPoints^, PathLength);
      for i := 0 to High(_LastPath^.Nodes) do
      Move(_LastPath^.Nodes[i]^, WayPoints^[i], SizeOf(TG2IntS32) * 2);
    end;
  end
  else
  begin
    SetLength(_LastPath^.Nodes, 0);
    if WayPoints <> nil then
    SetLength(WayPoints^, 0);
  end;
  Result := _LastPath;
end;
//TG2PathFinder END

end.
