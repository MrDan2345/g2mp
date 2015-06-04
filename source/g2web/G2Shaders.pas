unit G2Shaders;

//The contents of this software are used with permission, subject to
//the Mozilla Public License Version 1.1 (the "License"); you may
//not use this software except in compliance with the License. You may
//obtain a copy of the License at
//http://www.mozilla.org/MPL/MPL-1.1.html
//
//Software distributed under the License is distributed on an
//"AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
//implied. See the License for the specific language governing
//rights and limitations under the License.
//
//This module is a part of g2mp game development framework.

interface

const
  VS_Prim: String = "
    uniform mat4 WVP;
    attribute vec3 a_Position0;
    attribute vec4 a_Color0;
    varying vec4 v_Color;
    void main () {
      gl_Position = vec4(a_Position0, 1) * WVP;
      v_Color = a_Color0;
    }
  ";
  VS_Pic: String = "
    uniform mat4 WVP;
    attribute vec3 a_Position0;
    attribute vec4 a_Color0;
    attribute vec2 a_TexCoord0;
    varying vec4 v_Color;
    varying vec2 v_TexCoord;
    void main () {
      gl_Position = vec4(a_Position0, 1) * WVP;
      v_Color = a_Color0;
      v_TexCoord = a_TexCoord0;
    }
  ";
  VS_SceneB0: String = "
    uniform mat4 WVP;
    attribute vec3 a_Position0;
    attribute vec2 a_TexCoord0;
    varying vec2 v_TexCoord;
    void main () {
      gl_Position = vec4(a_Position0, 1) * WVP;
      v_TexCoord = a_TexCoord0;
    }
  ";
  VS_SceneB0L: String = "
    uniform mat4 WVP;
    attribute vec3 a_Position0;
    attribute vec2 a_TexCoord0;
    attribute vec2 a_TexCoord1;
    varying vec4 v_TexCoord;
    void main () {
      gl_Position = vec4(a_Position0, 1) * WVP;
      v_TexCoord = vec4(a_TexCoord0, a_TexCoord1);
    }
  ";
  VS_SceneB1: String = "
    const int MAX_BONE_COUNT = 60;
    uniform mat4 WVP;
    uniform mat4 SkinPallete[MAX_BONE_COUNT];
    attribute vec3 a_Position0;
    attribute vec2 a_TexCoord0;
    attribute float a_BlendIndex0;
    varying vec2 v_TexCoord;
    void main () {
      mat4 FinalMatrix = SkinPallete[int(a_BlendIndex0)];
      vec4 SkinPos = vec4(a_Position0, 1) * FinalMatrix;
      gl_Position = SkinPos * WVP;
      v_TexCoord = a_TexCoord0;
    }
  ";
  VS_SceneB1L: String = "
    const int MAX_BONE_COUNT = 60;
    uniform mat4 WVP;
    uniform mat4 SkinPallete[MAX_BONE_COUNT];
    attribute vec3 a_Position0;
    attribute vec2 a_TexCoord0;
    attribute vec2 a_TexCoord1;
    attribute float a_BlendIndex0;
    varying vec4 v_TexCoord;
    void main () {
      mat4 FinalMatrix = SkinPallete[int(a_BlendIndex0)];
      vec4 SkinPos = vec4(a_Position0, 1) * FinalMatrix;
      gl_Position = SkinPos * WVP;
      v_TexCoord = vec4(a_TexCoord0, a_TexCoord1);
    }
  ";
  VS_SceneB2: String = "
    const int MAX_BONE_COUNT = 60;
    uniform mat4 WVP;
    uniform mat4 SkinPallete[MAX_BONE_COUNT];
    attribute vec3 a_Position0;
    attribute vec2 a_TexCoord0;
    attribute vec2 a_BlendIndex0;
    attribute vec2 a_BlendWeight0;
    varying vec2 v_TexCoord;
    void main () {
      mat4 FinalMatrix = (
        SkinPallete[int(a_BlendIndex0[0])] * a_BlendWeight0[0] +
        SkinPallete[int(a_BlendIndex0[1])] * a_BlendWeight0[1]
      );
      vec4 SkinPos = vec4(a_Position0, 1) * FinalMatrix;
      gl_Position = SkinPos * WVP;
      v_TexCoord = a_TexCoord0;
    }
  ";
  VS_SceneB2L: String = "
    const int MAX_BONE_COUNT = 60;
    uniform mat4 WVP;
    uniform mat4 SkinPallete[MAX_BONE_COUNT];
    attribute vec3 a_Position0;
    attribute vec2 a_TexCoord0;
    attribute vec2 a_TexCoord1;
    attribute vec2 a_BlendIndex0;
    attribute vec2 a_BlendWeight0;
    varying vec4 v_TexCoord;
    void main () {
      mat4 FinalMatrix = (
        SkinPallete[int(a_BlendIndex0[0])] * a_BlendWeight0[0] +
        SkinPallete[int(a_BlendIndex0[1])] * a_BlendWeight0[1]
      );
      vec4 SkinPos = vec4(a_Position0, 1) * FinalMatrix;
      gl_Position = SkinPos * WVP;
      v_TexCoord = vec4(a_TexCoord0, a_TexCoord1);
    }
  ";
  VS_SceneB3: String = "
    const int MAX_BONE_COUNT = 60;
    uniform mat4 WVP;
    uniform mat4 SkinPallete[MAX_BONE_COUNT];
    attribute vec3 a_Position0;
    attribute vec2 a_TexCoord0;
    attribute vec3 a_BlendIndex0;
    attribute vec3 a_BlendWeight0;
    varying vec2 v_TexCoord;
    void main () {
      mat4 FinalMatrix = (
        SkinPallete[int(a_BlendIndex0[0])] * a_BlendWeight0[0] +
        SkinPallete[int(a_BlendIndex0[1])] * a_BlendWeight0[1] +
        SkinPallete[int(a_BlendIndex0[2])] * a_BlendWeight0[2]
      );
      vec4 SkinPos = vec4(a_Position0, 1) * FinalMatrix;
      gl_Position = SkinPos * WVP;
      v_TexCoord = a_TexCoord0;
    }
  ";
  VS_SceneB3L: String = "
    const int MAX_BONE_COUNT = 60;
    uniform mat4 WVP;
    uniform mat4 SkinPallete[MAX_BONE_COUNT];
    attribute vec3 a_Position0;
    attribute vec2 a_TexCoord0;
    attribute vec2 a_TexCoord1;
    attribute vec3 a_BlendIndex0;
    attribute vec3 a_BlendWeight0;
    varying vec4 v_TexCoord;
    void main () {
      mat4 FinalMatrix = (
        SkinPallete[int(a_BlendIndex0[0])] * a_BlendWeight0[0] +
        SkinPallete[int(a_BlendIndex0[1])] * a_BlendWeight0[1] +
        SkinPallete[int(a_BlendIndex0[2])] * a_BlendWeight0[2]
      );
      vec4 SkinPos = vec4(a_Position0, 1) * FinalMatrix;
      gl_Position = SkinPos * WVP;
      v_TexCoord = vec4(a_TexCoord0, a_TexCoord1);
    }
  ";
  VS_SceneB4: String = "
    const int MAX_BONE_COUNT = 60;
    uniform mat4 WVP;
    uniform mat4 SkinPallete[MAX_BONE_COUNT];
    attribute vec3 a_Position0;
    attribute vec2 a_TexCoord0;
    attribute vec4 a_BlendIndex0;
    attribute vec4 a_BlendWeight0;
    varying vec2 v_TexCoord;
    void main () {
      mat4 FinalMatrix = (
        SkinPallete[int(a_BlendIndex0[0])] * a_BlendWeight0[0] +
        SkinPallete[int(a_BlendIndex0[1])] * a_BlendWeight0[1] +
        SkinPallete[int(a_BlendIndex0[2])] * a_BlendWeight0[2] +
        SkinPallete[int(a_BlendIndex0[3])] * a_BlendWeight0[3]
      );
      vec4 SkinPos = vec4(a_Position0, 1) * FinalMatrix;
      gl_Position = SkinPos * WVP;
      v_TexCoord = a_TexCoord0;
    }
  ";
  VS_SceneB4L: String = "
    const int MAX_BONE_COUNT = 60;
    uniform mat4 WVP;
    uniform mat4 SkinPallete[MAX_BONE_COUNT];
    attribute vec3 a_Position0;
    attribute vec2 a_TexCoord0;
    attribute vec2 a_TexCoord1;
    attribute vec4 a_BlendIndex0;
    attribute vec4 a_BlendWeight0;
    varying vec4 v_TexCoord;
    void main () {
      mat4 FinalMatrix = (
        SkinPallete[int(a_BlendIndex0[0])] * a_BlendWeight0[0] +
        SkinPallete[int(a_BlendIndex0[1])] * a_BlendWeight0[1] +
        SkinPallete[int(a_BlendIndex0[2])] * a_BlendWeight0[2] +
        SkinPallete[int(a_BlendIndex0[3])] * a_BlendWeight0[3]
      );
      vec4 SkinPos = vec4(a_Position0, 1) * FinalMatrix;
      gl_Position = SkinPos * WVP;
      v_TexCoord = vec4(a_TexCoord0, a_TexCoord1);
    }
  ";
  VS_SceneParticles: String = "
    uniform mat4 WVP;
    uniform mat4 TransformPallete[60];
    attribute vec3 a_Position0;
    attribute vec2 a_TexCoord0;
    attribute float a_BlendIndex0;
    varying vec2 v_TexCoord;
    varying vec4 v_Color;
    void main () {
      int ind = int(a_BlendIndex0);
      gl_Position = (
        vec4(a_Position0 * mat3(TransformPallete[ind]) +
        vec3(
          TransformPallete[ind][0][3],
          TransformPallete[ind][1][3],
          TransformPallete[ind][2][3]
        ), 1) * WVP
      );
      v_TexCoord = a_TexCoord0;
      v_Color = vec4(
        TransformPallete[ind][3][0],
        TransformPallete[ind][3][1],
        TransformPallete[ind][3][2],
        TransformPallete[ind][3][3]
      );
    }
  ";

  PS_Prim: String = "
    #ifdef GL_ES
    precision mediump float;
    #endif
    varying vec4 v_Color;
    void main () {
      gl_FragColor = v_Color;
    }
  ";
  PS_Pic: String = "
    #ifdef GL_ES
    precision mediump float;
    #endif
    uniform sampler2D Tex0;
    varying vec4 v_Color;
    varying vec2 v_TexCoord;
    void main () {
      gl_FragColor = texture2D(Tex0, v_TexCoord) * v_Color;
    }
  ";
  PS_Scene: String = "
    #ifdef GL_ES
    precision mediump float;
    #endif
    uniform sampler2D Tex0;
    uniform vec4 LightAmbient;
    varying vec2 v_TexCoord;
    void main () {
      gl_FragColor = texture2D(Tex0, v_TexCoord) * LightAmbient;
    }
  ";
  PS_SceneL: String = "
    #ifdef GL_ES
    precision mediump float;
    #endif
    uniform sampler2D Tex0;
    uniform sampler2D Tex1;
    uniform vec4 LightAmbient;
    varying vec4 v_TexCoord;
    void main () {
      gl_FragColor = texture2D(Tex0, v_TexCoord.xy) * (texture2D(Tex1, v_TexCoord.zw) + LightAmbient);
    }
  ";
  PS_SceneParticles: String = "
    #ifdef GL_ES
    precision mediump float;
    #endif
    uniform sampler2D Tex0;
    varying vec2 v_TexCoord;
    varying vec4 v_Color;
    void main () {
      gl_FragColor = texture2D(Tex0, v_TexCoord) * v_Color;
    }
  ";

implementation

end.
