'use strict';

let file_in = null;
let file_out = null;
let elem = document.getElementById("generate");
elem.addEventListener("click", generate);

// simulation classes
class Ride {
  constructor(id,start_x,start_y,end_x,end_y,early,fin_time) {
    this.id = id;
    this.start_x = start_x;
    this.start_y = start_y;
    this.end_x = end_x;
    this.end_y = end_y;
    this.early = early;
    this.fin_time = fin_time;
  }
  distance() {
    return Math.abs(this.start_x - this.end_x) + Math.abs(this.start_y - this.end_y);
  }
}

class Car {
  constructor(id) {
    this.id = id;
    this.x = 0;
    this.y = 0;
    this.rides = [];
    this.step = 0;
  }
  go_to_ride_start(ride) {
    let dist_to_ride = Math.abs(this.x - ride.start_x) + Math.abs(this.y - ride.start_y);
    this.step += dist_to_ride;
    this.x = ride.start_x;
    this.y = ride.start_y;
    return this.step;
  }
}

function readUrl(input, flag) {
  if (input.files && input.files[0]) {
    let data = null;
    let reader = new FileReader();
    reader.onload = (e) => {
      data = e.target.result;
      if(flag == "input") {
        file_in = data;
      } else if(flag == "output"){
        file_out = data;
      }
      let name = input.files[0].name;
      input.setAttribute("data-title", "Uploaded `${flag}` file");
    }
    reader.readAsText(input.files[0]);
  }
}

function check_files() {
  return (file_in && file_out) ? true : false;
}

function parse(input, output) {
  // parsing input file
  let parsed_input = input.split("\n").map(x => x.split(" "));
  parsed_input.pop();
  for (let i = 0; i < parsed_input.length; i++) {
    parsed_input[i] = parsed_input[i].map(y => parseInt(y, 10));
  }

  // parsing output file
  let parsed_output = output.split("\n").map(x => x.split(" "));
  parsed_output.pop();

  for (let i = 0; i < parsed_output.length; i++) {
    //console.log(parsed_output[i].pop());
    parsed_output[i] = parsed_output[i].map(y => parseInt(y, 10));
  }
  console.log(parsed_output);
  console.log(parsed_input);
  //
  let world_data = parsed_input[0];
  let fleet = parsed_input[0][2];
  parsed_input.shift();

  let rides_list = [];
  let cars = []
  // creating list of rides
  for(let i = 0; i < parsed_input.length; i++) {
    rides_list.push(new Ride(i, parsed_input[i][0], parsed_input[i][1], parsed_input[i][2], parsed_input[i][3], parsed_input[i][4], parsed_input[i][5]));
  }
  // assigning each car it's rides ids
  for(let i = 0; i < fleet; i++) {
    cars.push(new Car(i));
    parsed_output[i].shift(); // the first digit of output is number of rides assigned to the car, so we do not need it
    cars[cars.length - 1].rides = cars[cars.length - 1].rides.concat(parsed_output[i]);
  }
  console.log(cars);
  return [world_data, rides_list, cars];
}

function generate() {
  if(check_files()) {
    let res = parse(file_in, file_out);
    let world_data = res[0];
    let step = world_data[5];
    let rides_list = res[1];
    let cars = res[2];
    // get canvas
    let canvas = document.getElementById('canv');
    let context = canvas.getContext("2d");
    context.clearRect(0, 0, canvas.width, canvas.height);
    
    for(let i = 0; i < rides_list.length && i < 100; i++) {
      let ride_id = rides_list.length > 100 ? Math.floor(Math.random()*rides_list.length) : i;
      let ride = rides_list[ride_id];
      let current_car = find(ride, cars);
      let colors = color(ride, current_car, step, canvas, world_data, rides_list);
      let bonus_color = colors[0];
      let ride_color = colors[1];
      draw(ride, bonus_color, ride_color, canvas, world_data);
    }
  } else {
    alert("Impossible to visualize. Files or file missing.");
  }
}

function find(ride, cars) {
  for(let i = 0; i < cars.length; i++) {
    for(let j = 0; j < cars[i].rides.length; j++) {
      if(cars[i].rides[j] == ride.id) {
        return cars[i];
      }
    }
  }
  console.log(ride.id);
  return null;
}
// actually this function doenst draws but searches colors for ride
function color(ride, car, step, canvas, world_data, rides_list) {
  // check if ride skipped
  //console.log(car);
  if(car == null)
    return ['red', 'red'];

  // set step to zero as we want to start a new simulation for this car(it may be not zero, because of previous simulations)
  car.x = 0;
  car.y = 0;
  car.step = 0

  let index = car.rides.indexOf(ride.id);
  for(let i = 0; i < car.rides.length; i++) {
    let dist_to_ride = Math.abs(car.x - rides_list[car.rides[i]].start_x) + Math.abs(car.y - rides_list[car.rides[i]].start_y);
    car.step += dist_to_ride;
    car.x = rides_list[car.rides[i]].start_x;
    break;
    car.y = rides_list[car.rides[i]].start_y;
    // break if we found ride and at it's start position
    if(i == index)
    car.step += rides_list[car.rides[i]].distance();
    car.x = rides_list[car.rides[i]].end_x;
    car.y = rides_list[car.rides[i]].end_y;
  }
  if(ride.early > car.step)
    car.step = ride.early;
    var bonus_color = 'yellow';

  if(car.step + ride.distance() <= ride.fin_time) {
    var ride_color = 'green';
  } else {
    var ride_color = 'orange';
  }

  if(bonus_color != 'yellow')
    bonus_color = ride_color;

  return [bonus_color, ride_color];
}

function draw(ride, bonus_color, ride_color, canvas, world_data) {
    //console.log(bonus_color, ride_color);
    let context = canvas.getContext("2d");
    context.lineWidth = 2;
    // make scales
    let scale_x = canvas.width/world_data[0];
    let scale_y = canvas.height/world_data[1];

    // coords in pixels
    let start_x_scaled = Math.floor(ride.start_x*scale_x);
    let start_y_scaled = Math.floor(ride.start_y*scale_y);
    let end_x_scaled = Math.floor(ride.end_x*scale_x);
    let end_y_scaled = Math.floor(ride.end_y*scale_y);
    let radius = 3;
    // reverse coordinta systems
    start_y_scaled = canvas.height - start_y_scaled;
    end_y_scaled = canvas.height - end_y_scaled;

    // drawing dot
    context.beginPath();
    context.strokeStyle = bonus_color;
    context.arc(start_x_scaled, start_y_scaled, radius, 0, 2 * Math.PI, false);
    context.fillStyle = bonus_color;
    context.fill();
    context.lineWidth = 2;
    context.stroke();
    // drawing lines
    context.beginPath();
    context.strokeStyle = ride_color;
    context.moveTo(start_x_scaled, start_y_scaled);
    context.lineTo(end_x_scaled, start_y_scaled);
    context.stroke();
    context.beginPath();
    context.strokeStyle = ride_color;
    context.moveTo(end_x_scaled, start_y_scaled);
    context.lineTo(end_x_scaled, end_y_scaled);
    context.stroke();
}
