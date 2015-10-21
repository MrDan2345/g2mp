bl_info = {
  "name": "Gen2 Mesh Format",
  "author": "Andrey Martynov (Dan)",
  "blender": (2,6,2),
  "version": (0,0,1),
  "location": "File > Import-Export",
  "description": "Export g2m format",
  "category": "Import-Export"
}

import bpy
import array
import struct
import mathutils
from bpy.props import *
from bpy_extras.io_utils import ExportHelper
from mathutils import Matrix

class G2Animation(bpy.types.PropertyGroup):
#begin
  #anim_name = bpy.props.StringProperty(name = "", default = "Animation");
  #value = bpy.props.IntProperty(name = "Test Prop", default = 22);
  list_controls = bpy.props.StringProperty(name = "List Control", default = "", options = {"HIDDEN"});
#end

bpy.utils.register_class(G2Animation);

class G2MButtonAnimAddRemove(bpy.types.Operator):
#begin
  bl_label = "Add Remove Animation"
  bl_idname = "g2_anim.add_remove"
  do_add = bpy.props.BoolProperty(default = True);
  
  def execute(self, context):
  #begin
    obj = bpy.types.Scene.g2m_exporter;
    anims = obj.animations;
    if self.do_add:
    #begin
      new_anim = anims.add();
      new_anim.name = "Anim" + str(len(anims) - 1);
    #end
    else:
    #begin
      if (obj.anim_index > -1) and (obj.anim_index < len(anims)):
      #begin
        anims.remove(obj.anim_index);
        obj.anim_index -= 1;
      #end
    #end
    return {'FINISHED'};
  #end
#end

bpy.utils.register_class(G2MButtonAnimAddRemove);

class ExportG2M(bpy.types.Operator, ExportHelper):
#begin
  bl_idname = "export_g2m.g2m";
  bl_label = "Gen2 Mesh Format";
  bl_options = {'PRESET'};
  bl_context = "object";

  filename_ext = ".g2m";
  base_frame = bpy.props.IntProperty(
    name = "Base Frame", 
    default = 0,
    step = 1
  );
  object_types = EnumProperty(
    name = "Data Types",
    options = {'ENUM_FLAG'},
    items = (
      ('GEOMETRY', "Geometry", ""),
      ('ANIMATION', "Animation", ""),
      ('MATERIALS', "Materials", ""),
      ('SKINNING', "Skinning", ""),
      ('LIGHTS', "Lights", ""),
    ),
    default = {'GEOMETRY'},
  );
  
  animations = bpy.props.CollectionProperty(type = G2Animation);
  anim_index = bpy.props.IntProperty(min = -1, default = -1);
  
  anim_name = bpy.props.StringProperty(name = "Name", default = "");
  anim_start = bpy.props.IntProperty(name = "Start", default = 0);
  anim_end = bpy.props.IntProperty(name = "End", default = 0);
  
  def draw(self, context):
  #begin
    layout = self.layout;
    obj = context.object;
    row = layout.row();
    row.label("Export Data");
    row = layout.row();
    box = row.box();
    box.prop(self, "object_types");
    box.prop(self, "base_frame");
    row = layout.row();
    row.label("Animation Options");
    row = layout.row();
    box = row.box();
    box.label("Animations:");
    # box.template_list(self, "animations", self, "anim_index", prop_list = 'list_controls', rows = 5);
    # split = box.split(percentage = 0.5);
    # col = split.column();
    # op = col.operator("g2_anim.add_remove", text = "Add");
    # op.do_add = True;
    # col = split.column();
    # op = col.operator("g2_anim.add_remove", text = "Remove");
    # op.do_add = False;
    # box.prop(self, "anim_name");
    # split = box.split(percentage = 0.5);
    # col = split.column();
    # col.prop(self, "anim_start");
    # col = split.column();
    # col.prop(self, "anim_end");
  #end
  
  def invoke(self, context, event):
  #begin
    bpy.types.Scene.g2m_exporter = self;
    return super().invoke(context, event);
  #end
  
  def execute(self, context):
  #begin
    class tg2_geom:
    #begin
      node_id = -1;
      node = None;
      geom = None;
      vertices = [];
      colors = [];
      tex_coords = [];
      faces = [];
      materials = [];
      def add_tex_layer(self):
      #begin
        self.tex_coords.append([]);
      #end
      def add_color(self, col):
      #begin
        for i in range(0, len(self.colors)):
        #begin
          c = self.colors[i];
          if abs(c[0] - col[0]) < 0.01 and abs(c[1] - col[1]) < 0.01 and abs(c[2] - col[2]) < 0.01:
          #begin
            return i;
          #end
        #end
        self.colors.append(col);
        return len(self.colors) - 1;
      #end
      def add_tex_coord(self, tl, tex_coord):
      #begin
        for i in range(0, len(self.tex_coords[tl])):
        #begin
          tc = self.tex_coords[tl][i];
          if abs(tc[0] - tex_coord[0]) < 0.0001 and abs(tc[1] - tex_coord[1]) < 0.0001:
          #begin
            return i;
          #end
        #end
        self.tex_coords[tl].append(tex_coord);
        return len(self.tex_coords[tl]) - 1;
      #end
      def add_face_colors(self, c0, c1, c2):
      #begin
        i0 = self.add_color(c0);
        i1 = self.add_color(c1);
        i2 = self.add_color(c2);
        return [i0, i1, i2];
      #end
      def add_face_tex_coords(self, tl, tc0, tc1, tc2):
      #begin
        i0 = self.add_tex_coord(tl, tc0);
        i1 = self.add_tex_coord(tl, tc1);
        i2 = self.add_tex_coord(tl, tc2);
        return [i0, i1, i2];
      #end
      def create_material_layer(self, mat):
      #begin
        later = {};
        layer['name'] = mat.name;
        layer['two_sided'] = False;
        layer['ambient_color'] = [0, 0, 0];
        layer['diffuse_color'] = [0, 0, 0];
        layer['specular_color'] = [0, 0, 0];
        layer['specular_color_amount'] = 0;
        layer['specular_power'] = 1;
        layer['emmissive_color'] = [0, 0, 0];
        layer['emmissive_color_amount'] = 0;
        layer['ambient_map_enable'] = False;
        layer['ambient_map'] = '';
        layer['ambient_map_amount'] = 0;
        layer['diffuse_map_enable'] = False;
        layer['diffuse_map'] = '';
        layer['diffuse_map_amount'] = 0;
        layer['specular_map_enable'] = False;
        layer['specular_map'] = '';
        layer['specular_map_amount'] = 0;
        layer['opacity_map_enable'] = False;
        layer['opacity_map'] = '';
        layer['opacity_map_amount'] = 0;
        layer['light_map_enable'] = False;
        layer['light_map'] = '';
        layer['light_map_amount'] = 0;
        layer['bump_map_enable'] = False;
        layer['bump_map'] = '';
        layer['bump_map_amount'] = 0;
        return layer;
      #end
      def generate(self):
      #begin
        self.vertices = [];
        self.colors = [];
        self.tex_coords = [];
        self.faces = [];
        for v in self.geom.vertices:
        #begin
          self.vertices.append(v.co);
        #end
        if len(self.geom.uv_layers) == 0:
        #begin
          self.add_tex_layer();
        #end
        else:
        #begin
          for l in self.geom.uv_layers:
          #begin
            self.add_tex_layer();
          #end
        #end
        for i in range(0, len(self.geom.tessfaces)):
        #begin
          f = self.geom.tessfaces[i];
          fc = None;
          ft = [];
          if len(self.geom.tessface_vertex_colors) == 0:
          #begin
            fc = [[1, 1, 1], [1, 1, 1], [1, 1, 1], [1, 1, 1]];
          #end
          else:
          #begin
            fcd = self.geom.tessface_vertex_colors[0].data[i];
            fc = [fcd.color1, fcd.color2, fcd.color3, fcd.color4];
          #end
          if len(self.geom.tessface_uv_textures) == 0:
          #begin
            ft.append([0, 0], [0, 0], [0, 0], [0, 0]);
          #end
          else:
          #begin
            for tc in self.geom.tessface_uv_textures:
            #begin
              ft.append([tc.data[i].uv1, tc.data[i].uv2, tc.data[i].uv3, tc.data[i].uv4]);
            #end
          #end
          f_col = self.add_face_colors(fc[0], fc[1], fc[2]);
          f_tex = [];
          for t in range(0, len(self.tex_coords)):
          #begin
            f_tex.append(self.add_face_tex_coords(t, ft[t][0], ft[t][1], ft[t][2]));
          #end
          f_vert = [f.vertices[0], f.vertices[1], f.vertices[2]];
          self.faces.append([f_vert, f_col, f_tex, f.material_index]);
          if len(f.vertices) > 3:
          #begin
            f_col = self.add_face_colors(fc[2], fc[3], fc[0]);
            f_tex = [];
            for t in range(0, len(self.tex_coords)):
            #begin
              f_tex.append(self.add_face_tex_coords(t, ft[t][2], ft[t][3], ft[t][0]));
            #end
            f_vert = [f.vertices[2], f.vertices[3], f.vertices[0]];
            self.faces.append([f_vert, f_col, f_tex, f.material_index]);
          #end
        #end
        for m in self.geom.materials:
        #begin
          mat_layers = [];
          layer = self.create_material_layer(m);
          mat_layers.append(layer);
          for tex in m.texture_slots:
          #begin
            
          #end
          self.materials.append(mat_layers);
        #end
      #end
      def __init__(self, geom_object, object_id):
      #begin
        self.node_id = object_id;
        self.node = geom_object;
        self.geom = geom_object.to_mesh(bpy.context.scene, True, 'PREVIEW');
        if not self.geom.tessfaces and self.geom.polygons:
        #begin
          self.geom.calc_tessface();
        #end
        self.generate();
      #end
    #end
    scope = bpy.data.objects;
    geoms = [];
    for i in range(0, len(scope)):
    #begin
      n = scope[i];
      if n.type == 'MESH':
      #begin
        g = tg2_geom(n, i);
        geoms.append(g);
      #end
    #end
    def get_node_id(node):
    #begin
      nonlocal scope;
      for i in range(0, len(scope)):
      #begin
        if node == scope[i]: return i;
      #end
      return -1;
    #end
    scene = bpy.context.scene;
    file = open(self.filepath, 'wb');
    file.write(b'G2M ');
    h_pos = file.tell();
    def write_float(f):
    #begin
      file.write(struct.pack('f', f));
    #end
    def write_matrix_4x3(mat):
    #begin
      mlh = Matrix([[1, 0, 0, 0], [0, 0, 1, 0], [0, 1, 0, 0], [0, 0, 0, 1]]);
      m = mlh * mat;
      for i in range(0, 4):
      #begin
        for j in range(0, 3):
        #begin
          file.write(struct.pack('f', m[j][i]));
        #end
      #end
    #end
    def write_vector3(v):
    #begin
      for i in range(0, 3):
      #begin
        file.write(struct.pack('f', v[i]));
      #end
    #end
    def write_vector2(v):
    #begin
      for i in range(0, 2):
      #begin
        file.write(struct.pack('f', v[i]));
      #end
    #end
    def write_color(c):
    #begin
      for i in range(0, 3):
      #begin
        file.write(struct.pack('B', int(c[i] * 255.0)));
      #end
    #end
    def write_int(i):
    #begin
      file.write(struct.pack('i', i));
    #end
    def write_int3(v):
    #begin
      for i in range(0, 3):
      #begin
        file.write(struct.pack('i', v[i]));
      #end
    #end
    def write_str_nt(s):
    #begin
      file.write(s.encode('utf-8'));
      file.write(struct.pack('b', 0));
    #end
    def block_start(name):
    #begin
      nonlocal h_pos;
      file.write(name.encode('utf-8'));
      h_pos = file.tell();
      file.write(struct.pack('i', 0));
      print('block start [' + name + '] ' + str(h_pos));
    #end
    def block_end():
    #begin
      nonlocal h_pos;
      s_pos = file.tell();
      block_size = s_pos - h_pos - 4;
      file.seek(h_pos);
      file.write(struct.pack('i', block_size));
      file.seek(s_pos);
      print('block end size = ' + str(block_size));
    #end
    
    #nodes export begin
    block_start('NMAP');
    write_int(len(scope));
    print('node count = ' + str(len(scope)));
    node_offsets = [];
    for i in range(0, len(scope)):
    #begin
      node_offsets.append(file.tell());
      write_int(0);
    #end
    block_end();
    block_start('NDAT');
    for i in range(0, len(scope)):
    #begin
      p = file.tell(); 
      file.seek(node_offsets[i]);
      write_int(p);
      file.seek(p);
      n = scope[i];
      ind = -1;
      if n.parent: ind = get_node_id(n.parent);
      write_int(ind);
      write_str_nt(n.name);
      write_matrix_4x3(n.matrix_world);
    #end
    block_end();
    #nodes export end
    
    #geoms export begin
    block_start('GMAP');
    write_int(len(geoms));
    print('geom count = ' + str(len(geoms)));
    geom_offsets = [];
    for i in range(0, len(geoms)):
    #begin
      geom_offsets.append(file.tell());
      write_int(0);
    #end
    block_end();
    block_start('GDAT');
    for i in range(0, len(geoms)):
    #begin
      p = file.tell(); 
      file.seek(geom_offsets[i]);
      write_int(p);
      file.seek(p);
      g = geoms[i];
      write_int(g.node_id);
      write_int(len(g.vertices));
      write_int(len(g.colors));
      write_int(len(g.faces));
      write_int(len(g.materials));
      write_int(len(g.tex_coords));
      print('node id = ' + str(g.node_id));
      print('vcount = ' + str(len(g.vertices)));
      print('ccount = ' + str(len(g.colors)));
      print('fcount = ' + str(len(g.faces)));
      print('mcount = ' + str(len(g.materials)));
      print('tcount = ' + str(len(g.tex_coords)));
      for v in g.vertices:
      #begin
        write_vector3(v);#[v[0], v[2], v[1]]);
      #end;
      for c in g.colors:
      #begin
        write_color(c);
      #end
      for tc in g.tex_coords:
      #begin
        write_int(len(tc));
        for t in tc:
        #begin
          write_vector2(t);
        #end
      #end
      for m in g.materials:
      #begin
        write_int(m);
      #end
      for f in g.faces:
      #begin
        f_vert = f[0];
        f_col = f[1];
        f_tex = f[2];
        f_mat = f[3];
        write_int3(f_vert);
        write_int3(f_col);
        for tc in f_tex:
        #begin
          write_int3(tc);
        #end
        write_int(0);
        write_int(f_mat);
      #end
      '''
      print(type(g).__name__);
      materials = [];
      colors = [];
      f_vertices = [];
      f_colors = [];
      f_tex_coords = [];
      for f in g.tessfaces:
      #begin
        f_verices.append([f.vertices[0], f.verices[1], f.vertices[2]]);
        if len(f.vertices) > 3:
        #begin
          f_verices.append([f.vertices[2], f.verices[1], f.vertices[3]);
        #end
      #end
      if len(g.vertex_colors) == 0:
      #begin
        colors.append([1.0, 1.0, 1.0]);
        for f in f_vertices:
        #begin
          f_colors.append([0, 0, 0]);
        #end
      #end
      else:
      #begin
        for c in g.vertex_colors:
        #begin
          colors.append(c.color);
        #end
        for f in g.tessface_vertex_colors:
        #begin
          f_colors.append([]);
        #end
      #end
      write_int(geom_node_id[i]);
      face_count = 0;
      for f in range(0, len(g.tessfaces)):
      #begin
        if len(g.tessfaces[f].vertices) == 4:
        #begin
          print('quad face!');
        #end
        face_count += len(g.tessfaces[f].vertices) - 2;
        material_added = False;
        for m in materials:
        #begin
          if m == g.tessfaces[f].material_index:
          #begin
            material_added = True;
            break;
          #end
        #end
        if not material_added:
        #begin
          materials.append(g.tessfaces[f].material_index);
        #end
      #end
      write_int(len(g.vertices));
      write_int(len(colors));
      write_int(face_count);
      write_int(len(materials));
      print('len(g.uv_layers) = ' + str(len(g.uv_layers)));
      #if len(g.uv_layers) == 0:
      if len(g.uv_layers) == 0:
      #begin
        write_int(1);
      #end
      else:
      #begin
        #write_int(len(g.uv_layers));
        write_int(len(g.uv_layers));
      #end
      for v in g.vertices:
      #begin
        write_vector3(v.co);
      #end
      for c in colors:
      #begin
        write_color(c);
      #end
      if len(g.uv_layers) == 0:
      #begin
        write_int(1);
        write_vector2([0.0, 0.0]);
      #end
      else:
      #begin
        for uvl in g.uv_layers:
        #begin
          write_int(len(uvl.data));
          for uv in uvl.data:
          #begin
            write_vector2(uv.uv);
          #end
        #end
      #end;
      for m in materials:
      #begin
        write_int(m);
      #end
      for f in range(0, len(g.tessfaces)):
      #begin
        face = g.tessfaces[f];
        for t in range(0, len(face.vertices) - 2):
        #begin
          tri = [face.vertices[0], face.vertices[t + 1], face.vertices[t + 2]];
          write_int(tri[0]);
          write_int(tri[1]);
          write_int(tri[2]);
          if len(g.vertex_colors) == 0:
          #begin
            write_int(0);
            write_int(0);
            write_int(0);
          #end
          else:
          #begin
            write_int(tri[0]);
            write_int(tri[1]);
            write_int(tri[2]);
          #end
          if len(g.uv_layers) == 0:
          #begin
            write_int(0);
            write_int(0);
            write_int(0);
          #end
          else:
          #begin
            for uvl in g.uv_layers:
            #begin
              write_int(tri[0]);
              write_int(tri[1]);
              write_int(tri[2]);
            #end
          #end
          write_int(0);
          write_int(face.material_index);
        #end
      #end
      '''
    #end
    block_end();
    #geoms export end
    file.close();
    return {'FINISHED'};
  #end
#end

def menu_func(self, context):
#begin
  self.layout.operator(ExportG2M.bl_idname, text="Gen2 Mesh (.g2m)");
#end

def register():
#begin
  bpy.utils.register_module(__name__);
  bpy.types.INFO_MT_file_export.append(menu_func);
#end

def unregister():
#begin
  bpy.utils.unregister_module(__name__);
  bpy.types.INFO_MT_file_export.remove(menu_func);
#end

if __name__ == "__main__": register();