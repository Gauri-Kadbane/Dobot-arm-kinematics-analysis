# Dobot Magician Lite — Kinematics & Workspace Analysis

A complete kinematic analysis of the Dobot Magician Lite robotic arm, including forward kinematics derived via the Denavit–Hartenberg convention, inverse kinematics solved symbolically in MATLAB, a URDF model built from CAD, and a 3D workspace analysis with Yoshikawa manipulability mapping.

---

## Repository Structure

```
dobot-magician-lite-kinematics/
├── matlab/
│   ├── forward_kinematics.m
│   ├── workspace_analysis.m
│   ├── show_robot.m
│   └── dobot_tree.m
├── urdf/
│   ├── modelrobot.urdf
│   ├── base.stl
│   ├── link1.stl
│   ├── link2.stl
│   ├── link3.stl
│   ├── EE.stl
│   ├── EEjoint.stl
│   └── gripper.stl
├── plots/
└── README.md
```

---

## Robot Overview

The Dobot Magician Lite is a 3-DOF educational robotic arm modeled as an **R ⊥ R ∥ R** manipulator.

| Parameter | Value | Description |
|-----------|-------|-------------|
| a₁ | 53.5 mm | Base height offset |
| a₂ | 150 mm | Upper arm length |
| a₃ | 150 mm | Forearm length |

**Joint limits:**

| Joint | Min | Max | Description |
|-------|-----|-----|-------------|
| t1 | −90° | +90° | Base yaw |
| t2 | −10° | +80° | Shoulder pitch |
| t3 | −110° | +10° | Elbow pitch |

---

## Forward Kinematics

`forward_kinematics.m` builds transformation matrices H₀₁, H₁₂, H₂₃ using the DH convention and multiplies them symbolically:

```
H03 = H01 · H12 · H23
```

End-effector position equations:

```
Px = cos(t1) · (90 + a2·sin(t2) + a3·sin(t3 − t2))
Py = sin(t1) · (90 + a2·sin(t2) + a3·sin(t3 − t2))
Pz = a1 − a2·cos(t2) − a3·cos(t3 − t2)
```

---

## Inverse Kinematics

IK was solved using MATLAB's `solve()` function on the symbolic FK equations, then validated interactively using the **Inverse Kinematics Designer** app with the `dobot_tree` model.

---

## URDF & Robot Model

**`show_robot.m`** imports `modelrobot.urdf` via `importrobot()`, renders the arm in 3D, and saves a PNG to `matlab/figs/robot_model.png`.

> **Note:** Keep the folder structure intact after cloning — `show_robot.m` resolves the URDF path relative to its own location.

**`dobot_tree.m`** builds the robot as a `rigidBodyTree` with 4 joints. Usage:

```matlab
P.Hs    = 0.0535;   % base height (m)
P.L2    = 0.150;    % upper arm (m)
P.L3    = 0.150;    % forearm (m)
P.Ltool = 0.0;      % tool offset (m)

robot = dobot_tree(P);
show(robot);
```

---

## Workspace Analysis

`workspace_analysis.m` samples 4000 random joint configurations within the physical joint limits and applies FK to each to map the reachable workspace. Points are colored by the **Yoshikawa manipulability index** (√det(J·Jᵀ)), highlighting dexterous regions vs. near-singular poses.

Outputs a 3D scatter plot and three orthographic projections (XY, XZ, YZ). The workspace has a characteristic **semi-spherical dome shape** typical of 3-DOF planar arms.

---

## Getting Started

**Requirements**
- MATLAB R2021b or later
- Symbolic Math Toolbox
- Robotics System Toolbox

**Run the scripts**

```matlab
% Forward Kinematics
forward_kinematics

% Visualize robot model
show_robot

% Workspace analysis
workspace_analysis

% Build rigidBodyTree for IK Designer
P.Hs=0.0535; P.L2=0.150; P.L3=0.150; P.Ltool=0;
robot = dobot_tree(P);
show(robot);
```

---
