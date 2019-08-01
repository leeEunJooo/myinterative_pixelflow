import java.util.ArrayList;

import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.softbodydynamics.DwPhysics;
import com.thomasdiewald.pixelflow.java.softbodydynamics.constraint.DwSpringConstraint;
import com.thomasdiewald.pixelflow.java.softbodydynamics.particle.DwParticle;
import com.thomasdiewald.pixelflow.java.softbodydynamics.particle.DwParticle2D;
import com.thomasdiewald.pixelflow.java.softbodydynamics.softbody.DwSoftBody2D;
import com.thomasdiewald.pixelflow.java.softbodydynamics.softbody.DwSoftGrid2D;
import com.thomasdiewald.pixelflow.java.utils.DwStrokeStyle;

import controlP5.Accordion;
import controlP5.ControlP5;
import processing.core.*;
import processing.opengl.PGraphics2D;


  int viewport_x = 0;
  int viewport_y = 0;
  
  
  // physics parameters
  DwPhysics.Param param_physics = new DwPhysics.Param();
  
  // particle parameters
  DwParticle.Param param_particle_cloth1 = new DwParticle.Param();
  
  // spring parameters
  DwSpringConstraint.Param param_spring_cloth1 = new DwSpringConstraint.Param();
  
  // physics simulation
  DwPhysics<DwParticle2D> physics;
  
  // cloth objects
  DwSoftGrid2D cloth1 = new DwSoftGrid2D();
  
  // list, that wills store the cloths
  ArrayList<DwSoftBody2D> softbodies = new ArrayList<DwSoftBody2D>();
  
  
  PGraphics2D tex_cloth_left;
  


  // 0 ... default: particles, spring
  // 1 ... tension
  int DISPLAY_MODE = 0;
  
  // entities to display
  boolean DISPLAY_PARTICLES      = true;
  boolean DISPLAY_MESH           = !true;
  boolean DISPLAY_SRPINGS        = true;
  boolean DISPLAY_SPRINGS_STRUCT = true;
  boolean DISPLAY_SPRINGS_SHEAR  = true;
  boolean DISPLAY_SPRINGS_BEND   = true;
  boolean UPDATE_PHYSICS         = true;
  
  // first thing to do, inside draw()
  boolean NEED_REBUILD = false;
  
  public void setup() {
    //size(1280, 720, P2D); 
    //size(displayWidth, displayHeight, P2D);
    fullScreen(P2D);
    smooth(8);
    surface.setLocation(viewport_x, viewport_y);  //browser location
    
    // main library context
    DwPixelFlow context = new DwPixelFlow(this);
    
    physics = new DwPhysics<DwParticle2D>(param_physics);

    //gravity, bound
    param_physics.GRAVITY = new float[]{ 0, 0.2f };
    param_physics.bounds  = new float[]{ 0, 0, width, height };
    
    param_physics.iterations_collisions = 4;
    param_physics.iterations_springs    = 4;
    
    // particle parameters for Cloth1
    param_particle_cloth1.DAMP_BOUNDS    = 0.50000f;
    param_particle_cloth1.DAMP_COLLISION = 0.99999f;
    param_particle_cloth1.DAMP_VELOCITY  = 0.99100f; 
    
    // spring parameters for Cloth1
    param_spring_cloth1.damp_dec = 0.999999f;
    param_spring_cloth1.damp_inc = 0.000199f;
    
    // initial cloth building parameters, both cloth start the same
    cloth1.CREATE_STRUCT_SPRINGS = true;
    cloth1.CREATE_SHEAR_SPRINGS  = true;
    cloth1.CREATE_BEND_SPRINGS   = true;
    cloth1.bend_spring_mode      = 0;
    cloth1.bend_spring_dist      = 1;

    createBodies();
    createGUI();
    frameRate(60);
  }
  
  
  //create body function
  public void createBodies(){
    
    physics.reset();
    softbodies.clear();
    softbodies.add(cloth1);
    
    cloth1.setParticleColor(color(255, 180,   0, 128));
    cloth1.setMaterialColor(color(255, 180,   0, 128));
    cloth1.setParam(param_particle_cloth1);
    cloth1.setParam(param_spring_cloth1);

    // both cloth are of the same size
    int nodes_x = 106;
    int nodes_y = 50;
    int nodes_r = 8;  //particle circle
    int nodes_start_x = 0;
    int nodes_start_y = 0;
    
    int   num_cloth = softbodies.size();
    float cloth_width = 2 * nodes_r * (nodes_x-1);  //diameter * crossnum
    float spacing = 0;  //cloth start point
    //float spacing = (width - num_cloth * cloth_width) / (float)(num_cloth+1);
    
    // create all cloth in the list
    for(int i = 0; i < num_cloth; i++){
      nodes_start_x += spacing + cloth_width * i;
      DwSoftGrid2D cloth = (DwSoftGrid2D)softbodies.get(i);
      cloth.create(physics, nodes_x, nodes_y, nodes_r, nodes_start_x, nodes_start_y);
      
      //fix spots
      for(int j=0; j<cloth.nodes_x; j++){
        cloth.getNode(j, 0).enable(false, false, false); // fix node to current location
        cloth.getNode(j, cloth.nodes_y-1).enable(false, false, false); // fix node to current location
      }
      cloth.createShapeParticles(this);
    }
  }

  public void draw() {

    if(NEED_REBUILD){
      createBodies();  // create body 
      NEED_REBUILD = false;
    }
    
    updateMouseInteractions();
    // update physics simulation
    physics.update(1);
    background(255);
      
    //for(arrayname : byeonsu name)
    // 3) mesh, solid
    if(DISPLAY_MESH){
      for(DwSoftBody2D body : softbodies){
        body.createShapeMesh(this.g);
      }
    }
    
    
    // 1) particles
    if(DISPLAY_PARTICLES){
      for(DwSoftBody2D body : softbodies){
        body.displayParticles(this.g);
      }
    }
    
    // 2) mesh, solid
    if(DISPLAY_MESH){
      for(DwSoftBody2D body : softbodies){
        body.displayMesh(this.g);
      }
    }
    
    // interaction stuff
    if(DELETE_SPRINGS){
      fill(255,64);
      stroke(0);
      strokeWeight(1);
      ellipse(mouseX, mouseY, DELETE_RADIUS*2, DELETE_RADIUS*2);
    }


    // info
    int NUM_SPRINGS   = physics.getSpringCount();
    int NUM_PARTICLES = physics.getParticlesCount();
    
    //title
    String txt_fps = String.format(getClass().getName()+ "   [particles %d]   [springs %d]   [frame %d]   [fps %6.2f]", NUM_PARTICLES, NUM_SPRINGS, frameCount, frameRate);
    surface.setTitle(txt_fps);
  }
  
  // this resets all springs and particles, to some of its initial states
  // can be used after deactivating springs with the mouse
  public void repairAllSprings(){
    for(DwSoftBody2D body : softbodies){
      for(DwParticle pa : body.particles){
        pa.setCollisionGroup(body.collision_group_id);
        pa.setRadiusCollision(pa.rad());
        pa.enableAllSprings(true);
      }
    }
  }
  
  
  // update all springs rest-lengths, based on current particle position
  // the effect is, that the body keeps the current shape
  public void applySpringMemoryEffect(){
    ArrayList<DwSpringConstraint> springs = physics.getSprings();
    for(DwSpringConstraint spring : springs){
      spring.updateRestlength();
    }
  }
  
  
  
  //////////////////////////////////////////////////////////////////////////////
  // User Interaction
  //////////////////////////////////////////////////////////////////////////////
 
  DwParticle particle_mouse = null;
  
  public DwParticle findNearestParticle(float mx, float my){
    return findNearestParticle(mx, my, Float.MAX_VALUE);
  }
  
  //I have to edit this 
  public DwParticle findNearestParticle(float mx, float my, float search_radius){
    float dd_min_sq = search_radius * search_radius;
    DwParticle2D[] particles = physics.getParticles();
    DwParticle particle = null;
    for(int i = 0; i < particles.length; i++){
      float dx = mx - particles[i].cx;
      float dy = my - particles[i].cy;
      float dd_sq =  dx*dx + dy*dy;
      if( dd_sq < dd_min_sq){
        dd_min_sq = dd_sq;
        particle = particles[i];
      }
    }
    return particle;
  }
  
  public ArrayList<DwParticle> findParticlesWithinRadius(float mx, float my, float search_radius){
    float dd_min_sq = search_radius * search_radius;
    DwParticle2D[] particles = physics.getParticles();
    ArrayList<DwParticle> list = new ArrayList<DwParticle>();
    for(int i = 0; i < particles.length; i++){
      float dx = mx - particles[i].cx;
      float dy = my - particles[i].cy;
      float dd_sq =  dx*dx + dy*dy;
      if(dd_sq < dd_min_sq){
        list.add(particles[i]);
      }
    }
    return list;
  }
  
  
  public void updateMouseInteractions(){
    if(cp5.isMouseOver()) return; 
    
    // deleting springs/constraints between particles
    if(DELETE_SPRINGS){
      ArrayList<DwParticle> list = findParticlesWithinRadius(mouseX, mouseY, DELETE_RADIUS);
      for(DwParticle tmp : list){
        tmp.enableAllSprings(false);
        tmp.collision_group = physics.getNewCollisionGroupId();
        tmp.rad_collision = tmp.rad;
      }
    } else {
      if(particle_mouse != null){
        float[] mouse = {mouseX, mouseY};
        particle_mouse.moveTo(mouse, 0.2f);
      }
    }
  }
  
  
  boolean DELETE_SPRINGS = false;
  float   DELETE_RADIUS = 20;

  public void mousePressed(){
    boolean mouseInteraction = !cp5.isMouseOver();
    if(mouseInteraction){
      if(mouseButton == RIGHT ) DELETE_SPRINGS = true; 
      if(!DELETE_SPRINGS){
        particle_mouse = findNearestParticle(mouseX, mouseY, 100);
        if(particle_mouse != null) particle_mouse.enable(false, false, false);
      }
    }
  }
  
  public void mouseReleased(){
    if(!DELETE_SPRINGS && particle_mouse != null){
      if(mouseButton == LEFT  ) particle_mouse.enable(true, true, true);
      if(mouseButton == CENTER) particle_mouse.enable(true, false, false);
      particle_mouse = null;
    }
    if(mouseButton == RIGHT ) DELETE_SPRINGS = false;
  }
  
  //////////////////////////////////////////////////////////////////////////////
  // GUI STUFF
  //////////////////////////////////////////////////////////////////////////////
  
  
  public void cloth1_CREATE_SPRING_TYPE  (float[] val){
    cloth1.CREATE_STRUCT_SPRINGS = (val[0] > 0);
    cloth1.CREATE_SHEAR_SPRINGS  = (val[1] > 0);
    cloth1.CREATE_BEND_SPRINGS   = (val[2] > 0);
    NEED_REBUILD = true;
  }
  public void cloth1_BEND_SPRING_MODE(int val){
    cloth1.bend_spring_mode = val;
    NEED_REBUILD = true;
  }
  public void cloth1_BEND_SPRING_LEN(int val){
    cloth1.bend_spring_dist = val;
    NEED_REBUILD = true;
  }
  
  
  
  
  public void setDisplayMode(int val){
    DISPLAY_MODE = val;
  }

  public void setDisplayTypes(float[] val){
    DISPLAY_PARTICLES = (val[0] > 0);
    DISPLAY_MESH      = (val[1] > 0);
    DISPLAY_SRPINGS   = (val[2] > 0);
  }
  
  public void setGravity(float val){
    physics.param.GRAVITY[1] = val;
  }

  ControlP5 cp5;
  public void createGUI(){
    cp5 = new ControlP5(this);
    int sx, sy, px, py, oy;
    sx = 100;
    sy = 14;
    oy = (int)(sy*1.4f);
  }
  
