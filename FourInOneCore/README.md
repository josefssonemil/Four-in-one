# FourInOneCore

Support development of 4-in-1 applications.


## Overview

The FourInOneCore framework implements the basics of a 4-in-1 application, that is an application where several locally connected devices are used to form a shared space where som kind of activity takes place.
The classes in the framework support setting the connection between devices and managing a subsequent 4-in-1 session.

## Architecture

The framework is designed to handle a situation where 2 or 4 devices are connected to each other. To handle the set up phase you use a `FourInOneSetupManager` and to manage a session a subclass of `FourInOneSessionManager`. Both of these have delegates that are needed to handle application specific needs. The `FourInOneSetupManager`  works together with a subclass of  `FourInOneConnectingViewController` and the session manager with a subclass of `FourInOneSessionViewController`.

The 4-in-1 framework assumes that devices are arranged like this
````
---------
| 2 | 3 |
---------
| 1 | 4 |
---------
````
where the upper edge of each device is facing inwards. Thus in the figure above device 2 and 3 appear upside down. In order to form a large board the view in board 2 and 3 taking part in the board needs to be rotated 180 degrees, which is handled by the `FourInOneSessionViewController`. The framework also provides methods for translating between device coordinates and coordinates in the combined space. When UIKit is used for creating the user interface the origin of the combined coordinate system is in the upper left corner and if SpriteKit is used the origin is in the lower left corner.

When only 2 devices are involved in a session positions 1 and 2 are used. The positions are defined in the enumeration `DevicePosition`.  Regardless of the number devices connected the device in position 1 is supposed to act as a server for the session and is responsible for any required co-ordination between devices.

## Setup Phase and Session Phase

A 4-in-1 session is understood as consisting of 2 distinct phases. A setup phase where the connection between a number of devices is established and a session phase where the actual session takes place. It is assumed the 2 phases makes use of different views managed by different view controllers. That is, once the session has been setup using a `FourInOneSetupManager` and a `FourInOneConnectingViewController` the view is replaced by a view managed by a subclass of `FourInOneSessionManager` collaborating with a subclass of  `FourInOneSessionManager` handling communication between devices. Since sessions essentially can be about anything the `FourInOneSessionManager`  should be seen as an abstract class that must be subclassed to form one or more concrete subclasses to use in an application.

A session is limited to involving at most 4 devices. However, it is possible to run any number of sessions in parallell in the same location by making sure that each session has a different service identifier.

## Topics
### Classes

* The FourInOneCore framework is currently design to handle apps running in fullscreen landscape only. A `FourInOneNavigationController`  working together with a `FourInOneViewController`  implements that apps do not rotate the screen.

* A `FourInOneNavigationController` only allows rotation of the screen if its visible view controller allows rotation of the screen.

* The `FourInOneSetupManager` class manages the setup of a 4-in-1 session. Typically it can be used as is without subclassing. The set up manager interacts with an object implementing the `FourInOneSetupManagerDelegate` protocol.

*  The `FourInOneConnectingViewController` class implements the basic behaviour of a
view controller involved in a 4-in-1 set up session. It implements the methods of the `FourInOneSetupManagerDelegate` protocol and can show information to provide detail about the set up process that can be useful during development and debugging. To create a connecting view controller for a specific application it is necessary to create a subclass that implements the method `updateView(_:mode:inProgress:)` to describe what should happen in the view managed by the connecting view controller.

* The `FourInOneSessionManager` class implements the basic functionality for a 4-in-1 session.
This basic functionality is to send and receive `FourInOneEvent` objects between the participants
in a session. Since the class does not contain and specific knowledge about the needs of
any particular 4-in-1 application it needs to be subclassed to provide the details in each
specific case.

*  A `FourInOneSessionViewController` handles a few basic behaviours of view controllers involved in 4-in-1 sessions. The visible contents should be displayed in view connected to the `boardView` property, and the
session is managed by the `sessionManager`. To form a virtual area of all involved devices the boardView is rotated 180 degrees in position 2 and 3.


### Protocols

* The `FourInOneSetupManagerDelegate` protocol defines the methods that a delegate of a `FourInOneSetupManager` must implement.

* The `FourInOneSessionManagerDelegate` protocol defines the methods that a delegate of a `FourInOneSessionManager` must implement. The protocol defines only the most basic behaviour and it is expected that subclasses of `FourInOneSessionManager` need to extend it.


### Structures and Enumerations

* The `Platform` enumeration defines values for different platforms used to implement the suer interface of a session.

* The `GameMode` enumeration defines values describing the number of devices in a session.

* The `DevicePosition`enumeration Indicates the position of the current device in the virtual 4-in-1 board.

* A `FourInOneEvent` represents an event in a 4-in-1 session and is used to send information between devices.

* A `PeerInfo` structure contains additional information about a peer in a sessions. It is mainly used internally by the framework to keep track of the members in a session.


