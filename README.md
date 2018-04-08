# Vehicle Steering Using Model Predictive Control
The main goal of the project is to implement in C++ Model Predictive Control to drive the vehicle around the simulator track.


## The Model
The Model used in this project is a simple Kinematic Model consisting of Vehicle State and Actuators. 
Vehicle State refers to the state of the vehicle and can be represented as a vector containing the vehicle's x and y coordinates (`px`, `py`), orientation angle (`psi`), velocity (`v`), cross-track error or the distance of the vehicle from the expected trajectory (`cte`), and the error in the vehicle's orientation compared to the reference trajectory (`epsi`). 

Actuators are set of controls used to navigate the vehicle. For simplicity we only use 2 actuators which are represented as a vector containing the vehicle's acceleration (`a`) and the steering angle (`delta`). 
The model combines the state and actuations from the previous time step to calculate the state for the current time step based on the equations below:

<figure>
 <img src="eqns.png" width="716" height="468" alt="MPC Equations" align="middle" />
</figure>

In real world a vehicle cannot take very sharp turns due to vehicles turn radius, this has been accounted for in the model constraints and vehicle cannot turn more than +/-18 degree, which translates to +/- 0.33 radians (see `MPC.cpp` lines 189-192).


## Timestamp length and Frequency
This model predicts vehicle's state every 100 ms which is represented by `dt` in the kinematic equations above.
I choosed 100 ms because taking a value higher than this was giving inaccurate results as the environment was changing too fast for the predictive controller to give accurate results. Changing to a value less than 100 ms was also of not much use as we were unnecessarily making computations for 2 very similar states.

Also the model only predicts next 10 states which is represented by variable `N` in `MPC.cpp`.
I tried higher values of `N` such as 20 but this made the ipopt solver used in this project to not produce optimal results as I've constrained the solver to compute in less than 0.05 seconds (see `MPC.cpp` line 243).

This N multiplied by `dt` (0.1 *10) gives 1 second, so our predictive controller only predicts the set of states for 1 second in the future.

Adjusting either `N` or `dt` (even by small amounts) often produced erratic behavior. Other values tried include 20 / 0.05, 8 / 0.125, 6 / 0.15, and many others.


## Polynomial Fitting and MPC Preprocessing

I have used polynomial fitting of 3rd order on the way-points which are returned by simulator and used this polynomial to evaluate a reference trajectory for the vehicle path. The way-points are preprocessed by transforming them to the vehicle's perspective (see `main.cpp` lines 104-117). This simplifies the process to fit a polynomial to the way-points because the vehicle's x and y coordinates are now at the origin (0, 0) and the orientation angle is also zero. 


## Handling Latency

This project also factors in real world latency that can occur while applying actuator inputs. To simulate this the project's main thread sleeps for 100 ms before sending the actuations to simulator.
To account for this while returning the actuations to simulator I use 2 set of actuations - the real actuations for next step and the next predicted actuation after `dt`.
Sending the sum of these 2 actuations makes the model pro-actively apply the next actuation and hence handles the 100 ms latency.

---

## Dependencies

* cmake >= 3.5
 * All OSes: click [here](https://cmake.org/install/) for installation instructions.
* make >= 4.1(mac, linux), 3.81(Windows)
  * Linux: make is installed by default on most Linux distros
  * Mac: Install [Xcode command line tools](https://developer.apple.com/xcode/features/) to get make.
  * Windows: Click [here](http://gnuwin32.sourceforge.net/packages/make.htm) for installation instructions.
* gcc/g++ >= 5.4
  * Linux: gcc / g++ is installed by default on most Linux distros
  * Mac: same deal as make - Install [Xcode command line tools](https://developer.apple.com/xcode/features/)
  * Windows: recommend using [MinGW](http://www.mingw.org/)
* [uWebSockets](https://github.com/uWebSockets/uWebSockets)
  * Run either `install-mac.sh` or `install-ubuntu.sh`.
  * If you install from source, checkout to commit `e94b6e1`, i.e.
    ```
    git clone https://github.com/uWebSockets/uWebSockets
    cd uWebSockets
    git checkout e94b6e1
    ```
    Some function signatures have changed in v0.14.x. See [this PR](https://github.com/udacity/CarND-MPC-Project/pull/3) for more details.

* **Ipopt and CppAD:** Please refer to [this document](https://github.com/mohamedameen93/Vehicle-Steering-Using-Model-Predictive-Control/blob/master/install_Ipopt_CppAD.md) for installation instructions.
* [Eigen](http://eigen.tuxfamily.org/index.php?title=Main_Page). This is already part of the repo so you shouldn't have to worry about it.
* Simulator. You can download these from the [releases tab](https://github.com/udacity/self-driving-car-sim/releases).
* Not a dependency but read the [DATA.md](./DATA.md) for a description of the data sent back from the simulator.


## Basic Build Instructions

1. Clone this repo.
2. Run `build.sh`
3. Open the simulator and select MPC project.
4. Run `run.sh` 
- To clean the build, run `clean.sh`
