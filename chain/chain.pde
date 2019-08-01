import java.util.ArrayList;
import java.util.Arrays;

import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.softbodydynamics.DwPhysics;
import com.thomasdiewald.pixelflow.java.softbodydynamics.constraint.DwSpringConstraint;
import com.thomasdiewald.pixelflow.java.softbodydynamics.constraint.DwSpringConstraint2D;
import com.thomasdiewald.pixelflow.java.softbodydynamics.particle.DwParticle;
import com.thomasdiewald.pixelflow.java.softbodydynamics.particle.DwParticle2D;

import processing.core.*;
  
  int viewport_w = 1280;
  int viewport_h = 720;
  int viewport_x = 230;
  int viewport_y = 0;

  DwPhysics.Param param_physics = new DwPhysics.Param();
  DwParticle.Param param_chain = new DwParticle.Param();
  DwSpringConstraint.Param param_spring_chain = new DwSpringConstraint.Param();
  
  // physics simulation
  DwPhysics<DwParticle2D> physics;
 
  // all we need is an array of particles
  int particles_count = 0;
  DwParticle2D[] particles = new DwParticle2D[particles_count];

  
  boolean DISPLAY_PARTICLES = true;
  

  public void setup() {
    size(1280, 720, P2D); 
    smooth(8);
    surface.setLocation(230, 0);
    
    DwPixelFlow context = new DwPixelFlow(this);
    context.print();
    
    param_physics.GRAVITY = new float[]{ 0, 0.2f };
    param_physics.bounds  = new float[]{ 0, 0, width, height };
    param_physics.iterations_collisions = 4;
    param_physics.iterations_springs    = 4;
    
    param_chain.DAMP_BOUNDS          = 0.50f;
    param_chain.DAMP_COLLISION       = 0.9990f;
    param_chain.DAMP_VELOCITY        = 0.991f; 

    param_spring_chain.damp_dec = 0.99999f;
    param_spring_chain.damp_inc = 0.99999f;
    
    physics = new DwPhysics<DwParticle2D>(param_physics);
    
    for(int i = 0; i < 200; i++){
      float spawn_x = width/2 + random(-200, 200);
      float spawn_y = height/2 + random(-200, 200);
      createParticle(spawn_x, spawn_y);
    }

    frameRate(60);
}
  
  
public void reset(){
    particles_count = 0;
    particles = new DwParticle2D[particles_count];
}
  
public void createParticle(float spawn_x, float spawn_y){
    
    spawn_x += 1;
    spawn_y += 1;

   
    int   idx_curr = particles_count;
    int   idx_prev = idx_curr - 1;
    float radius_collision_scale = 1.1f;
    float radius   = 5; 
    float rest_len = radius * 3 * radius_collision_scale;
    
    DwParticle2D pa = new DwParticle2D(idx_curr);
    pa.setMass(5);
    pa.setParamByRef(param_chain);
    pa.setPosition(spawn_x, spawn_y);
    pa.setRadius(radius);
    pa.setRadiusCollision(radius * radius_collision_scale);
    pa.setCollisionGroup(idx_curr); // every particle has a different collision-ID
    addParticleToList(pa);

    if(idx_prev >= 0){
      DwParticle2D pb = particles[idx_prev];
      pa.px = pb.cx;
      pa.py = pb.cy;
      DwSpringConstraint2D.addSpring(physics, pb, pa, rest_len, param_spring_chain);
    }
  }
  
  
public void addParticleToList(DwParticle2D particle){
    if(particles_count >= particles.length){
      int new_len = (int) Math.max(2, Math.ceil(particles_count*1.5f) );
      if(particles == null){
        particles = new DwParticle2D[new_len];
      } else {
        particles = Arrays.copyOf(particles, new_len);
      }
    }
    particles[particles_count++] = particle;
    physics.setParticles(particles, particles_count);
  }
  
  
public void draw() {
    
    if(keyPressed && key == ' ') createParticle(mouseX, mouseY);
    
    updateMouseInteractions();    
 
    physics.update(1.1);
    background(255);
    noFill();
    strokeWeight(1);
    //beginShape(LINES);
    
    for(int i = 0; i < particles_count; i++){
      DwParticle2D pa = particles[i];
      for(int j = 0; j < pa.spring_count; j++){
        DwSpringConstraint2D spring = (DwSpringConstraint2D) pa.springs[j];
        if(spring.pa != pa) continue;
        if(!spring.enabled) continue;
        
        DwParticle2D pb = spring.pb;
        float force = Math.abs(spring.force);
        float r = force*5000f;
        float g = r/10;
        float b = 0;
        stroke(r,g,b);
        vertex(pa.cx, pa.cy);
        vertex(pb.cx, pb.cy);
        
      }
    }
    endShape();
    
    if(DISPLAY_PARTICLES){
      noStroke();
      fill(0);
      for(int i = 0; i < particles_count; i++){
        DwParticle2D particle = particles[i];
        ellipse(particle.cx, particle.cy, particle.rad*2, particle.rad*2);
        //rectMode(CENTER);
        //rect(particle.cx, particle.cy, particle.rad*2, particle.rad*2);
      }
    }

    if(DELETE_SPRINGS){
      fill(255,64);
      stroke(0);
      strokeWeight(1);
      ellipse(mouseX, mouseY, DELETE_RADIUS*2, DELETE_RADIUS*2);
    }

    // info
    int NUM_SPRINGS   = physics.getSpringCount();
    int NUM_PARTICLES = physics.getParticlesCount();
    String txt_fps = String.format(getClass().getName()+ "   [particles %d]   [springs %d]   [frame %d]   [fps %6.2f]", NUM_PARTICLES, NUM_SPRINGS, frameCount, frameRate);
    surface.setTitle(txt_fps);
  }
  
  DwParticle2D particle_mouse = null;
  
  public DwParticle2D findNearestParticle(float mx, float my, float search_radius){
    float dd_min_sq = search_radius * search_radius;
    DwParticle2D particle = null;
    for(int i = 0; i < particles_count; i++){
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
    ArrayList<DwParticle> list = new ArrayList<DwParticle>();
    for(int i = 0; i < particles_count; i++){
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
  float   DELETE_RADIUS  = 3;

  public void mousePressed(){
    if(mouseButton == RIGHT ) DELETE_SPRINGS = true;
    
    if(!DELETE_SPRINGS){
      particle_mouse = findNearestParticle(mouseX, mouseY, 100);
      if(particle_mouse != null) particle_mouse.enable(false, false, false);
    }
  }
  
  public void mouseReleased(){
    if(particle_mouse != null && !DELETE_SPRINGS){
      if(mouseButton == LEFT  ) particle_mouse.enable(true, true,  true );
      if(mouseButton == CENTER) particle_mouse.enable(true, false, false);
      particle_mouse = null;
    }
    if(mouseButton == RIGHT ) DELETE_SPRINGS = false;
  }
