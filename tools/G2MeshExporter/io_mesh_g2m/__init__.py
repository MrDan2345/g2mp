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
from bpy.props import *
from bpy_extras.io_utils import ExportHelper

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
    scope = bpy.data.objects;
    geoms = [];
    geom_node_id = [];
    for i in range(0, len(scope)):
    #begin
      n = scope[i];
      if n.type == 'MESH':
      #begin
        g = n.to_mesh(bpy.context.scene, True, 'PREVIEW');
        if g is not None:
        #begin
          if not g.tessfaces and g.polygons:
          #begin
            mesh.calc_tessface();
          #end
          geoms.append(g);
          geom_node_id.append(i);
        #end
      #end
    #end
    def node_id(node):
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
    def write_matrix_4x3(mat):
    #begin
      for i in range(0, 4):
      #begin
        for j in range(0, 3):
        #begin
          file.write(struct.pack('f', mat[i][j]));
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
      print('block start ' + str(h_pos));
    #end
    def block_end():
    #begin
      nonlocal h_pos;
      s_pos = file.tell();
      block_size = s_pos - h_pos;
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
      if n.parent: ind = node_id(n.parent);
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
      materials = [];
      colors = [];
      if len(g.vertex_colors) == 0:
      #begin
        colors.append([1.0, 1.0, 1.0]);
      #end
      else:
      #begin
        for c in g.vertex_colors:
        #begin
          colors.append(c.color);
        #end
      #end
      write_int(geom_node_id[i]);
      g = geoms[i];
      face_count = 0;
      for f in range(0, len(g.tessfaces)):
      #begin
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
      if len(g.uv_layers) == 0:
      #begin
        write_int(1);
      #end
      else:
      #begin
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
            write_vector2(uv);
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