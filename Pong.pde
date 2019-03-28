float player_xpos;
float player_ypos;
float player_velocity;
float player_height;
float player_width;
float enemy_distance;
float enemy_ypos;
float enemy_xpos;
float enemy_velocity;
float ball_xpos;
float ball_ypos;
float ball_xvelocity;
float ball_yvelocity;
float ball_size;
float distance;
int score;
int highscore;
PFont font;

int enable_mouse = 1;
int enable_guidelines = 0;

void setup() {
  fullScreen();
  rectMode(CENTER);
  noStroke();
  frameRate(60);

  font = loadFont("alienfont.vlw");
  textFont(font, 25);
  //Player and ball size (can be changed)
  player_height = 100;
  player_width = 10;
  ball_size = 10;


  //Player Velocity (only used for keymode)
  player_velocity = 10;
  enemy_velocity = 3;

  //Player start position
  player_xpos = player_width / 2;
  player_ypos = height / 2;
  enemy_xpos = width - (player_width / 2);
  //Ball start position
  ball_xpos = width / 2;
  ball_ypos = height / 2;

  //Ball start velocity
  ball_xvelocity = -4;
  ball_yvelocity = 0;


  score = 0;
  highscore = 0;
}






void draw() {
  //Clear everything
  background(100, 0, 0);

  //Player movement
  if (enable_mouse == 0) {
    if (keyPressed) {
      if (keyCode == DOWN) {
        player_ypos += player_velocity;
      } else if (keyCode == UP) {
        player_ypos += -player_velocity;
      }
      //constrain player_ypos
      player_ypos = constrain(player_ypos, 0 + (player_height / 2), height - (player_height / 2));
    }
  } else if (enable_mouse == 1) {
    player_ypos = constrain(mouseY, 0 + (player_height / 2), height - (player_height / 2));
  }

  //Ball movement
  ball_xpos = ball_xpos + ball_xvelocity;
  ball_ypos = ball_ypos + ball_yvelocity;

  //Enemy player movement
  enemy_ypos = constrain(enemy_ypos + constrain(ball_ypos - enemy_ypos, -enemy_velocity, enemy_velocity), 0 + player_height/2, height - player_height/2);

  //Collision check top and bottom
  if (ball_ypos <= 0 + (ball_size / 2 ) || ball_ypos >= height - (ball_size / 2 )) {
    ball_yvelocity = ball_yvelocity * -1;
  }

  //Collision check with enemy player
  if (ball_xpos >= width - player_width/2) {
    enemy_distance = enemy_ypos - ball_ypos;
    //If hit
    if (enemy_distance < ((player_height/2) + ball_size / 2) && enemy_distance > (-(player_height/2) - ball_size / 2)) {
      println("HIT: " + enemy_distance);
      //Reverse and increase ball velocity
      ball_xvelocity = (ball_xvelocity * -1) + 0.2;
      //change yvelocity according to hit position
      ball_yvelocity = ball_yvelocity - (enemy_distance / 20);
      ball_yvelocity = constrain(ball_yvelocity, -8, 8);
    } 
    //If no hit enemy
    else if (ball_xpos >= width - ball_size / 2) {
      println("GOAL!: " + enemy_distance);
      score += 3;
      ball_xpos = width / 2;
      ball_ypos = height / 2;
      ball_xvelocity = -3;
      ball_yvelocity = 0;
    }
  }



  //Collision check with player
  if (ball_xpos <= player_width + (ball_size/2)) {
    distance = player_ypos - ball_ypos;
    //If hit
    if (distance < ((player_height/2) + ball_size / 2) && distance > (-(player_height/2) - ball_size / 2)) {
      println("HIT: " + distance);
      //Reverse and increase ball velocity
      ball_xvelocity = (ball_xvelocity * -1) + 0.2;
      //change yvelocity according to hit position
      ball_yvelocity = ball_yvelocity - (distance / 20);
      ball_yvelocity = constrain(ball_yvelocity, -8, 8);
      score += 1;
    }
    //If no hit player
    else if (ball_xpos <= ball_size / 2) {
      println("MISS: " + distance);
      score = 0;
      ball_xpos = width / 2;
      ball_ypos = height / 2;
      ball_xvelocity = -3;
      ball_yvelocity = 0;
    }
  }

  //Display guidelines
  if (enable_guidelines == 1) {
    stroke(255, 50);
    line(0, (player_ypos - (player_height / 2)), width, (player_ypos - (player_height / 2)));
    line(0, (player_ypos + (player_height / 2)), width, (player_ypos + (player_height / 2)));
    line(0, player_ypos, width, player_ypos);
    noStroke();
  }

  //Display player
  rect(player_width / 2, player_ypos, player_width, player_height);

  //Display enemy player
  rect(width - (player_width / 2), enemy_ypos, player_width, player_height); 

  //Display ball
  rect(ball_xpos, ball_ypos, ball_size, ball_size);

  //Update and display scores
  if (score > highscore) {
    highscore = score;
  }
  text("Score: " + score, width - 500, 20);
  text("Highscore: " + score, width - 300, 20);
}