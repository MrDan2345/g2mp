unit G2Shaders;

interface

const G2Bin_StandardShaders: array[0..2650] of byte = (
  $47, $32, $53, $47, $00, $01, $0D, $00, $00, $00, $0D, $00, $00, $00, $05, $00, $00,
  $00, $78, $DA, $ED, $5D, $CB, $6F, $24, $47, $19, $AF, $7E, $4C, $3C, $EB, $EC,
  $E2, $48, $28, $97, $88, $90, $86, $E5, $30, $93, $58, $C9, $F4, $43, $49, $58,
  $83, $D8, $F5, $9A, $88, $15, $B3, $59, $07, $7B, $93, $95, $36, $D6, $30, $B1,
  $DB, $BB, $0D, $E3, $99, $D5, $4C, $8F, $71, $48, $90, $06, $71, $44, $48, $3E,
  $10, $21, $24, $90, $E6, $C0, $29, $2B, $21, $FF, $09, $20, $10, $4A, $0E, $88,
  $08, $71, $E4, $90, $C3, $5E, $91, $16, $30, $9C, $50, $CC, $57, $D5, $D5, $DD,
  $55, $FD, $9A, $9E, $F7, $C3, $BD, $2B, $CB, $55, $5F, $7D, $F5, $AE, $EF, $F7,
  $FD, $EA, $B3, $54, $BD, $84, $10, $7A, $73, $AB, $B2, $D9, $B4, $0E, $F2, $02,
  $42, $ED, $BA, $B5, $DF, $68, $1E, $28, $FB, $B5, $46, $D5, $36, $8E, $0C, $E5,
  $AD, $37, $37, $D7, $2E, $2D, $1F, $36, $AC, $3D, $E5, $A0, $6A, $D5, $95, $C2,
  $A5, $65, $45, $D9, $6D, $D4, $5B, $B6, $02, $39, $A2, $A6, $2B, $37, $EA, $9B,
  $8D, $96, $65, $5B, $8D, $FA, $15, $C5, $4D, $95, $56, $C3, $9A, $06, $68, $5E,
  $6F, $D4, $1A, $CD, $2B, $0A, $F9, $E5, $E8, $34, $DA, $B6, $5B, $7C, $AB, $6D,
  $C7, $B5, $C4, $6B, $71, $AD, $5C, $5A, $2E, $2A, $EF, $61, $1D, $A6, $BA, $F2,
  $75, $E5, $A0, $5D, $2B, $38, $35, $0A, $FE, $00, $57, $15, $B5, $B8, $8A, $67,
  $55, $5C, $A3, $35, $48, $1B, $A0, $4E, $87, $06, $E2, $1F, $5D, $5A, $FE, $13,
  $2C, $CB, $E5, $43, $B3, $D9, $C2, $4D, $A9, $1A, $74, $E1, $AE, $CC, $01, $1E,
  $81, $B3, $2A, $55, $DB, $6E, $5A, $EF, $B4, $6D, $53, $39, $34, $77, $75, $A5,
  $5A, $F1, $46, $1C, $2C, $34, $A0, $D0, $19, $2B, $5E, $CC, $6A, $F3, $5D, $AB,
  $7E, $CF, $91, $1F, $56, $DC, $5E, $99, $35, $A6, $D3, $B9, $57, $AB, $30, $D3,
  $C1, $EA, $05, $A6, $0F, $3C, $13, $E5, $79, $3A, $14, $C5, $6D, $08, $14, $99,
  $AE, $60, $26, $4F, $C1, $AE, $22, $F1, $B3, $B3, $CF, $CE, $9E, $45, $D7, $B7,
  $AF, $AD, $7F, $01, $B2, $DF, $46, $8E, $0C, $17, $E1, $BC, $F2, $63, $A4, $6C,
  $C0, $EF, $12, $16, $C3, $8F, $0C, $3F, $06, $72, $FE, $41, $FB, $48, $82, $FF,
  $32, $FC, $17, $A8, $EC, $B0, $55, $D1, $2A, $25, $74, $D3, $DA, $6D, $36, $5A,
  $8D, $7D, $5B, $29, $7C, $A7, $A8, $6C, $E8, $1B, $77, $BE, $AA, $6C, $DD, $AF,
  $EE, $99, $4D, $D8, $98, $83, $07, $56, $0D, $12, $E8, $0D, $84, $72, $32, $5A,
  $E9, $22, $D4, $F9, $06, $62, $FE, $3D, $E7, $74, $D5, $41, $68, $E5, $18, $A7,
  $97, $21, $2D, $40, $5A, $26, $DD, $AF, $80, $FC, $2B, $90, $BE, $DA, $95, $D1,
  $D3, $DD, $0B, $08, $06, $80, $84, $DF, $21, $F4, $08, $E4, $8F, $68, $5E, $24,
  $79, $C1, $CB, $CB, $24, $2F, $7A, $F9, $3C, $C9, $4B, $90, $17, $48, $5F, $2B,
  $9F, $80, $EE, $F1, $D9, $19, $42, $8B, $B3, $BB, $64, $47, $24, $BA, $4D, $74,
  $E7, $9E, $A0, $26, $6D, $ED, $B6, $A7, $64, $D1, $BC, $8E, $06, $3A, $DB, $E6,
  $D1, $F5, $46, $A3, $B9, $77, $45, $71, $53, $23, $B2, $7D, $BE, $5C, $C3, $E5,
  $11, $7D, $8D, $1A, $21, $14, $B6, $1F, $52, $E2, $66, $9C, $6D, $79, $46, $18,
  $DF, $01, $E3, $4A, $34, $28, $F1, $66, $99, $70, $FA, $7C, $B1, $06, $62, $66,
  $B0, $E3, $38, $97, $0A, $D3, $05, $29, $61, $47, $08, $AB, $53, $98, $33, $48,
  $C2, $E9, $1C, $A4, $C5, $09, $C0, $93, $93, $96, $3E, $15, $29, $54, $65, $27,
  $29, $E9, $24, $45, $C1, $DF, $B2, $03, $7F, $5B, $BB, $66, $DD, $5C, $2F, $3D,
  $33, $76, $08, $1C, $21, $BC, $8D, $07, $BE, $12, $70, $EA, $AF, $A3, $75, $84,
  $09, $67, $68, $D4, $87, $25, $E9, $54, $CC, $0B, $E5, $C9, $8D, $9D, $F2, $48,
  $9F, $BA, $94, $67, $31, $77, $3A, $CA, $FE, $9F, $E4, $EC, $BF, $FC, $F6, $44,
  $01, $A0, $14, $44, $80, $78, $55, $D5, $57, $55, $07, $E6, $42, $E3, $04, $0B,
  $4F, $DB, $9F, $11, $3B, $FC, $A2, $B3, $05, $A2, $30, $D6, $83, $15, $5B, $A8,
  $86, $7D, $D4, $98, $4E, $1D, $D5, $65, $56, $81, $19, $45, $71, $BE, $28, $4D,
  $8E, $A3, $34, $C2, $98, $29, $8D, $03, $3F, $4E, $FA, $22, $50, $9A, $0D, $02,
  $45, $D9, $89, $49, $45, $5D, $D4, $65, $58, $B5, $96, $5D, $B5, $AD, $5D, $0F,
  $45, $6C, $E5, $E6, $B5, $3B, $95, $F5, $5B, $AF, $7F, $B3, $72, $FD, $D6, $ED,
  $D7, $B7, $A1, $AF, $57, $F1, $9C, $63, $00, $2E, $20, $D6, $95, $AD, $EF, $5B,
  $F5, $CD, $6A, $AD, $66, $DA, $E6, $5D, $BE, $A5, $9D, $C9, $10, $22, $4F, $13,
  $CF, $E5, $46, $7D, $FD, $46, $7D, $CF, $DA, $35, $5B, $00, $9B, $EB, $35, $B3,
  $BE, $E7, $66, $C7, $42, $9E, $BC, $55, $78, $CD, $AA, $57, $6B, $37, $AB, $70,
  $4C, $8E, $60, $01, $D9, $35, $61, $46, $B4, $B3, $E6, $D7, $71, $74, $1A, $2D,
  $1F, $14, $13, $D0, $94, $69, $BD, $88, $25, $6B, $D1, $58, $4C, $9B, $4C, $4D,
  $D5, $7E, $1D, $B2, $9A, $84, $43, $F1, $32, $7B, $28, $18, $AB, $E2, $44, $C9,
  $87, $61, $14, $06, $48, $56, $08, $4A, $DD, $BD, $35, $8F, $FA, $E5, $0A, $64,
  $A0, $F1, $FB, $05, $93, $2F, $70, $CD, $17, $9D, $6D, $23, $E6, $ED, $6F, $5A,
  $8C, $ED, $32, $ED, $AE, $85, $0D, $DE, $AD, $9E, $96, $8B, $9C, $78, $2E, $A0,
  $E8, $B9, $80, $F7, $A8, $0B, $10, $19, $17, $60, $C3, $EF, $0D, $EA, $02, $1E,
  $C3, $CF, $26, $85, $EA, $EF, $12, $D9, $63, $02, $04, $7B, $54, $C6, $CC, $95,
  $BA, $07, $C9, $D3, $1F, $85, $CB, $38, $25, $2E, $E3, $EA, $55, $D6, $6D, $24,
  $B9, $0C, $91, $DE, $82, $73, $8E, $7B, $80, $34, $3A, $3E, $45, $A8, $FB, $22,
  $A9, $23, $9C, $E0, $7A, $AC, $3B, $39, $45, $1F, $74, $4F, $D1, $F7, $B0, $7B,
  $90, $05, $D0, $27, $EE, $44, $79, $04, $7D, $A2, $13, $47, $26, $12, $99, $C0,
  $C9, $64, $22, $13, $A9, $4C, $20, $1E, $23, $DF, $39, $45, $B7, $3D, $B7, $04,
  $6E, $A5, $F3, $98, $71, $4B, $38, $FF, $4F, $C6, $2D, $E1, $FC, $BF, $18, $B7,
  $84, $F3, $FF, $8E, $60, $C5, $99, $51, $CD, $B8, $51, $E1, $93, $48, $18, $3D,
  $6B, $09, $D4, $70, $5C, $EF, $F9, $38, $8A, $F8, $AB, $E5, $F2, $02, $B8, $CF,
  $61, $AE, $13, $63, $74, $B5, $C6, $62, $B9, $DA, $74, $17, $9D, $3F, $CF, $21,
  $56, $44, $30, $E0, $3E, $80, $C4, $98, $5F, $20, $49, $C3, $C0, $3F, $3A, $07,
  $0E, $DB, $BD, $E3, $B9, $CE, $5B, $62, $9C, $B7, $34, $C7, $CE, $3B, $78, $A7,
  $CC, $8C, $73, $C1, $8C, $B3, $1F, $C7, $CF, $5D, $9B, $B5, $9F, $2D, $F8, $B5,
  $59, $EB, $E5, $CC, $C3, $CD, $AE, $BF, $65, $5A, $F7, $EE, $DB, $9E, $BA, $93,
  $9D, $E8, $2D, $9B, $2C, $8D, $12, $C7, $00, $EE, $96, $76, $76, $E0, $B4, $30,
  $23, $05, $89, $F2, $42, $72, $1D, $35, $54, $47, $DD, $C1, $35, $8A, $33, $76,
  $73, $7F, $56, $9C, $5B, $6C, $E2, $D1, $27, $BA, $98, $1E, $A6, $E1, $EF, $20,
  $11, $47, $24, $04, $52, $70, $2C, $8A, $78, $D7, $F9, $BE, $63, $0E, $4B, $B8,
  $B6, $1A, $59, $9B, $3D, $36, $D3, $B8, $E4, $18, $E2, $F9, $89, $1C, $3C, $E7,
  $C4, $7F, $19, $22, $22, $E1, $00, $32, $43, $44, $A4, $13, $4C, $20, $72, $94,
  $88, $48, $E8, $F6, $B1, $43, $3A, $6E, $9F, $80, $20, $47, $C8, $09, $25, $17,
  $98, $C0, $60, $5D, $99, $10, $8F, $10, $69, $21, $24, $47, $70, $02, $D8, $A4,
  $3D, $91, $B6, $27, $30, $ED, $61, $99, $C0, $B4, $07, $63, $E9, $50, $62, $42,
  $EA, $8A, $81, $BA, $62, $A0, $AE, $18, $59, $57, $F6, $EA, $3A, $44, $85, $27,
  $40, $28, $40, $80, $50, $80, $00, $A1, $00, $01, $42, $31, $D1, $8B, $0C, $58,
  $32, $60, $19, $4F, $F4, $44, $2B, $FF, $25, $8B, $9E, $CC, $08, $E3, $32, $32,
  $C6, $35, $9A, $00, $CE, $4D, $71, $C1, $EE, $88, $C3, $62, $A9, $91, $61, $E9,
  $50, $77, $D4, $B2, $78, $3E, $03, $48, $2E, $87, $93, $19, $0E, $27, $25, $70,
  $38, $39, $81, $C3, $C9, $03, $70, $38, $39, $81, $C3, $C9, $3D, $38, $9C, $9C,
  $C0, $E1, $E4, $09, $73, $B8, $60, $10, $2B, $03, $A8, $0C, $A0, $66, $23, $88,
  $A6, $FF, $7E, $C1, $83, $68, $7A, $7F, $94, $4E, $3F, $57, $41, $B4, $5E, $75,
  $B4, $50, $1D, $6D, $26, $03, $6F, $77, $E7, $13, $4F, $F5, $64, $C8, $D4, $17,
  $E9, $7E, $9C, $AE, $B6, $16, $59, $5B, $9B, $F2, $ED, $FA, $FD, $73, $1D, $B6,
  $5B, $0A, $84, $ED, $96, $06, $09, $DB, $31, $F2, $0F, $41, $FE, $E1, $58, $C2,
  $79, $BC, $DC, $E9, $67, $D8, $30, $1F, $2F, $0F, $B6, $39, $99, $F0, $5F, $06,
  $6F, $19, $BC, $CD, $62, $F0, $50, $2F, $4B, $52, $16, $3C, $9C, $0D, $A6, $69,
  $64, $4C, $73, $7A, $01, $C7, $9F, $2E, $E0, $7D, $7E, $28, $F4, $36, $32, $F4,
  $9E, $62, $34, $E0, $E7, $59, $B8, $D2, $E3, $AE, $52, $02, $77, $4D, $19, $AE,
  $E4, $B8, $AB, $3C, $00, $77, $4D, $13, $C6, $0C, $72, $57, $B9, $07, $77, $4D,
  $13, $DE, $0C, $72, $57, $79, $C2, $DC, $35, $18, $F6, $CC, $60, $32, $83, $C9,
  $45, $08, $9A, $1A, $FF, $59, $F0, $A0, $A9, $D1, $1F, $95, $35, $B2, $A0, $69,
  $0F, $2A, $DB, $AB, $8E, $1E, $AA, $A3, $CF, $64, $A0, $F5, $97, $F3, $89, $E0,
  $46, $32, $48, $1B, $59, $24, $C2, $05, $E9, $74, $B5, $F5, $C8, $DA, $FA, $94,
  $E3, $18, $7F, $3C, $D7, $61, $DA, $95, $40, $98, $76, $65, $94, $61, $5A, $46,
  $7E, $06, $F2, $B3, $89, $86, $6F, $79, $B9, $D3, $FF, $B8, $C2, $BA, $BC, $3C,
  $D8, $D7, $64, $C2, $BD, $19, $C8, $66, $20, $3B, $B3, $20, $3B, $70, $B0, $D8,
  $28, $BF, $92, $05, $8B, $67, $84, $61, $1B, $19, $C3, $9E, $15, $86, $9D, $2E,
  $C0, $FC, $F1, $02, $46, $4E, $86, $F2, $17, $46, $E6, $2F, $66, $D2, $5F, $A4,
  $89, $BB, $FC, $3D, $0B, $4F, $7B, $9C, $5D, $4A, $E0, $EC, $43, $86, $A7, $39,
  $CE, $2E, $0F, $C0, $D9, $87, $09, $5B, $07, $39, $BB, $DC, $83, $B3, $0F, $13,
  $CE, $0E, $72, $76, $79, $C2, $9C, $3D, $18, $E6, $CE, $C0, $3A, $03, $EB, $85,
  $01, $EB, $7E, $F8, $FE, $E7, $B0, $1A, $26, $FB, $9B, $D5, $26, $B0, $FC, $9A,
  $D9, $EA, $8A, $B1, $6F, $72, $86, $C4, $DB, $CD, $6A, $BD, $85, $45, $EE, $AA,
  $BD, $5C, $9A, $CE, $5B, $75, $DE, $40, $C8, $5E, $8D, $EA, $15, $9D, $0D, $6B,
  $7F, $BF, $DD, $32, $07, $7C, $CE, $DC, $5B, $A5, $37, $DA, $D5, $3D, $6F, $80,
  $B0, $87, $A1, $55, $0B, $8E, $9F, $7B, $73, $07, $D7, $4E, $4B, $70, $0B, $EE,
  $25, $A0, $C8, $F5, $99, $44, $76, $69, $F3, $3C, $D9, $A5, $13, $F7, $FB, $74,
  $EC, $83, $6B, $14, $6C, $16, $0E, $FF, $6A, $54, $89, $1A, $5B, $A2, $C5, $96,
  $E8, $3B, $9C, $29, $25, $C7, $B4, $7F, $21, $A6, $78, $A5, $92, $13, $C5, $9C,
  $D4, $A9, $BC, $F9, $95, $F6, $23, $04, $F8, $68, $5B, $75, $3C, $FF, $F0, $7B,
  $20, $11, $C8, $41, $37, $29, $88, $3A, $80, $24, $B0, $02, $7A, $21, $B4, $02,
  $D0, $F4, $4E, $D1, $85, $3E, $3C, $7D, $DA, $80, $A2, $44, $AA, $72, $FB, $1D,
  $A7, $A3, $A6, $D0, $D1, $DC, $9D, $86, $BD, $F6, $1F, $EA, $64, $50, $34, $3E,
  $98, $C1, $BE, $44, $4E, $E6, $E9, $34, $13, $DD, $8F, $8E, $87, $BC, $DA, $43,
  $43, $ED, $A9, $A1, $F5, $D4, $F0, $CF, $2D, $F7, $70, $D1, $0B, $1E, $53, $FE,
  $49, $04, $53, $7E, $3F, $C0, $94, $EF, $50, $86, $7A, $9F, $61, $CA, $35, $2A,
  $0B, $F6, $8C, $1E, $3E, $7C, $E8, $B2, $E3, $AF, $8D, $9C, $31, $77, $66, $FD,
  $C5, $41, $CC, $C2, $3F, $91, $26, $F0, $02, $61, $06, $33, $19, $CC, $CC, $28,
  $CC, $10, $8E, $F7, $54, $14, $36, $C4, $10, $BD, $25, $7C, $1B, $77, $BE, $25,
  $D5, $C0, $D0, $90, $44, $D1, $D2, $7C, $0A, $2A, $F6, $23, $4F, $91, $9F, $6C,
  $DA, $0A, $BD, $70, $DF, $CF, $A7, $78, $5E, $6B, $56, $EF, $79, $FB, $51, $61,
  $9A, $7D, $40, $80, $F5, $0C, $C0, $F6, $F3, $1E, $D8, $5E, $A6, $32, $17, $C0,
  $30, $D8, $62, $F9, $83, $3E, $C0, $90, $05, $3D, $02, $0A, $F9, $97, $30, $08,
  $11, $50, $18, $D3, $54, $10, $FD, $38, $D0, $26, $F9, $38, $D0, $1F, $20, $D5,
  $AA, $1E, $3C, $80, $D1, $68, $1B, $98, $5B, $96, $7A, $D1, $EA, $D1, $7E, $EC,
  $87, $6D, $29, $6A, $73, $6D, $F3, $48, $DB, $28, $E0, $71, $B1, $A1, $CF, $22,
  $09, $D7, $32, $93, $FA, $4D, $EC, $87, $0D, $C2, $93, $1B, $C9, $27, $4D, $D8,
  $E5, $85, $31, $DA, $ED, $A6, $E9, $8D, $D3, $AF, $8D, $C7, $C9, $2D, $FE, $DF,
  $BC, $73, $F4, $45, $EF, $1C, $DD, $A2, $32, $F6, $85, $F8, $6F, $D1, $17, $E2,
  $B1, $6D, $61, $F9, $AB, $AE, $83, $86, $0E, $B0, $53, $96, $D1, $45, $90, $0B,
  $9E, $03, $1E, $F4, $CC, $F9, $E9, $CB, $27, $34, $7D, $8C, $F2, $2B, $DD, $75,
  $D2, $35, $39, $8B, $27, $28, $FF, $A8, $9B, $F3, $F3, $E4, $7C, $32, $67, $B5,
  $83, $CF, $EA, $BC, $AC, $3F, $5E, $2F, $49, $76, $17, $92, $2E, $6E, $DE, $B1,
  $06, $72, $3B, $8D, $B4, $07, $FE, $3A, $AA, $94, $F1, $85, $FC, $DA, $C1, $3B,
  $96, $59, $B7, $7B, $59, $CB, $60, $96, $50, $EA, $CF, $14, $02, $03, $82, $79,
  $FE, $36, $FD, $7E, $B8, $05, $64, $3F, $82, $53, $1B, $D7, $A6, $84, $47, $FC,
  $3F, $CF, $32, $82, $74, $F6, $2C, $96, $CE, $E2, $CD, $DB, $A6, $16, $B0, $C7,
  $58, $8B, $4B, $67, $D9, $5E, $B0, $D5, $08, $A0, $21, $30, $B4, $75, $B4, $D6,
  $D4, $97, $05, $75, $83, $16, $34, $7F, $3B, $46, $98, $C1, $C5, $E0, $32, $D3,
  $2D, $08, $19, $D9, $05, $C6, $C8, $CA, $FF, $8D, $B2, $32, $4E, $A0, $0E, $67,
  $76, $C6, $B8, $CD, $EE, $C5, $A3, $77, $F1, $AA, $14, $BC, $52, $95, $2B, $FD,
  $E1, $0F, $80, $89, $72, $23, $A6, $74, $EA, $1F, $FD, $6F, $73, $EC, $BA, $F4,
  $D8, $7F, $63, $64, $FB, $CF, $4C, $D6, $D7, $50, $39, $8D, $D8, $09, $BF, $2D,
  $B8, $76, $AD, $79, $76, $FD, $2B, $6A, $D7, $12, $63, $D7, $1F, $D0, $AB, $A9,
  $6B, $D7, $F7, $A9, $2D, $1E, $31, $76, $DD, $A1, $B2, $63, $22, $13, $38, $D9,
  $A0, $B6, $8E, $67, $D2, $97, $C1, $43, $1B, $BE, $CD, $BF, $C4, $D9, $BC, $9B,
  $16, $20, $ED, $5C, $F1, $BE, $D4, $C1, $7F, $8C, $70, $D2, $5F, $EE, $E0, $3F,
  $40, $30, $B8, $D0, $11, $00, $17, $70, $5E, $60, $70, $42, $0C, $E0, $84, $8B,
  $1B, $EE, $1F, $60, $82, $B8, $71, $EE, $0E, $94, $D4, $17, $EC, $B8, $02, $55,
  $A0, $82, $70, $1C, $FA, $A3, $81, $28, $70, $54, $C8, $76, $0A, $AE, $DF, $1B,
  $C8, $30, $3C, $78, $D0, $0B, $7D, $C6, $83, $47, $C3, $83, $27, $BF, $FE, $91,
  $B6, $82, $F3, $F8, $DA, $EE, $5E, $68, $F1, $A2, $C3, $15, $D1, $B5, $9C, $25,
  $D7, $72, $D6, $4B, $22, $05, $EA, $BC, $2F, $2A, $4B, $B4, $86, $AF, $A6, $CA,
  $21, $35, $B5, $9C, $0B, $A9, $69, $4F, $84, $D4, $B4, $F2, $52, $48, $4D, $CF,
  $87, $D4, $F4, $F2, $85, $90, $9A, $B1, $1C, $52, $33, $CA, $4F, $52, $B5, $B0,
  $F1, $5F, $A4, $F3, $FE, $3F, $22, $42, $F2, $86
);

implementation

end.
