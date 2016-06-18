{- This Source Code Form is subject to the terms of the Mozilla Public License,
   v. 2.0. If a copy of the MPL was not distributed with this file, you can
   obtain one at http://mozilla.org/MPL/2.0/.

   Copyright 2016 by Ian Mackenzie
   ian.e.mackenzie@gmail.com
-}


module OpenSolid.Core.Point3d
    exposing
        ( origin
        , alongAxis
        , onPlane
        , relativeTo
        , fromCoordinates
        , interpolate
        , midpoint
        , xCoordinate
        , yCoordinate
        , zCoordinate
        , coordinates
        , squaredDistanceFrom
        , distanceFrom
        , vectorTo
        , vectorFrom
        , distanceAlong
        , squaredDistanceFromAxis
        , distanceFromAxis
        , distanceFromPlane
        , signedDistanceFromPlane
        , scaleAbout
        , rotateAround
        , translateAlong
        , mirrorAcross
        , localizeTo
        , placeIn
        , projectOntoAxis
        , projectOnto
        , projectInto
        , plus
        , minus
        , toRecord
        , fromRecord
        )

import OpenSolid.Core.Types exposing (..)
import OpenSolid.Core.Vector3d as Vector3d
import OpenSolid.Core.Direction3d as Direction3d


origin : Point3d
origin =
    Point3d 0 0 0


alongAxis : Axis3d -> Float -> Point3d
alongAxis axis =
    Vector3d.alongAxis axis >> addTo axis.originPoint


onPlane : Plane3d -> ( Float, Float ) -> Point3d
onPlane plane =
    Vector3d.onPlane plane >> addTo plane.originPoint


relativeTo : Frame3d -> ( Float, Float, Float ) -> Point3d
relativeTo frame =
    Vector3d.relativeTo frame >> addTo frame.originPoint


fromCoordinates : ( Float, Float, Float ) -> Point3d
fromCoordinates ( x, y, z ) =
    Point3d x y z


interpolate : Point3d -> Point3d -> Float -> Point3d
interpolate startPoint endPoint =
    let
        displacement =
            vectorFrom startPoint endPoint
    in
        \t -> plus (Vector3d.times t displacement) startPoint


midpoint : Point3d -> Point3d -> Point3d
midpoint firstPoint secondPoint =
    interpolate firstPoint secondPoint 0.5


xCoordinate : Point3d -> Float
xCoordinate (Point3d x _ _) =
    x


yCoordinate : Point3d -> Float
yCoordinate (Point3d _ y _) =
    y


zCoordinate : Point3d -> Float
zCoordinate (Point3d _ _ z) =
    z


coordinates : Point3d -> ( Float, Float, Float )
coordinates (Point3d x y z) =
    ( x, y, z )


squaredDistanceFrom : Point3d -> Point3d -> Float
squaredDistanceFrom other =
    vectorFrom other >> Vector3d.squaredLength


distanceFrom : Point3d -> Point3d -> Float
distanceFrom other =
    squaredDistanceFrom other >> sqrt


vectorTo : Point3d -> Point3d -> Vector3d
vectorTo (Point3d x2 y2 z2) (Point3d x1 y1 z1) =
    Vector3d (x2 - x1) (y2 - y1) (z2 - z1)


vectorFrom : Point3d -> Point3d -> Vector3d
vectorFrom (Point3d x2 y2 z2) (Point3d x1 y1 z1) =
    Vector3d (x1 - x2) (y1 - y2) (z1 - z2)


distanceAlong : Axis3d -> Point3d -> Float
distanceAlong axis =
    vectorFrom axis.originPoint >> Vector3d.componentIn axis.direction


squaredDistanceFromAxis : Axis3d -> Point3d -> Float
squaredDistanceFromAxis axis =
    vectorFrom axis.originPoint
        >> Vector3d.crossProduct (Direction3d.asVector axis.direction)
        >> Vector3d.squaredLength


distanceFromAxis : Axis3d -> Point3d -> Float
distanceFromAxis axis =
    squaredDistanceFromAxis axis >> sqrt


distanceFromPlane : Plane3d -> Point3d -> Float
distanceFromPlane plane =
    abs << signedDistanceFromPlane plane


signedDistanceFromPlane : Plane3d -> Point3d -> Float
signedDistanceFromPlane plane =
    vectorFrom plane.originPoint >> Vector3d.componentIn plane.normalDirection


addTo (Point3d px py pz) (Vector3d vx vy vz) =
    Point3d (px + vx) (py + vy) (pz + vz)


scaleAbout : Point3d -> Float -> Point3d -> Point3d
scaleAbout centerPoint scale =
    vectorFrom centerPoint >> Vector3d.times scale >> addTo centerPoint


rotateAround : Axis3d -> Float -> Point3d -> Point3d
rotateAround axis angle =
    vectorFrom axis.originPoint
        >> Vector3d.rotateAround axis angle
        >> addTo axis.originPoint


translateAlong : Axis3d -> Float -> Point3d -> Point3d
translateAlong axis distance =
    plus (Vector3d.alongAxis axis distance)


mirrorAcross : Plane3d -> Point3d -> Point3d
mirrorAcross plane =
    vectorFrom plane.originPoint
        >> Vector3d.mirrorAcross plane
        >> addTo plane.originPoint


localizeTo : Frame3d -> Point3d -> Point3d
localizeTo frame =
    vectorFrom frame.originPoint
        >> Vector3d.localizeTo frame
        >> (\(Vector3d x y z) -> Point3d x y z)


placeIn : Frame3d -> Point3d -> Point3d
placeIn frame =
    coordinates >> relativeTo frame


projectOntoAxis : Axis3d -> Point3d -> Point3d
projectOntoAxis axis =
    vectorFrom axis.originPoint
        >> Vector3d.projectOntoAxis axis
        >> addTo axis.originPoint


projectOnto : Plane3d -> Point3d -> Point3d
projectOnto plane point =
    let
        signedDistance =
            signedDistanceFromPlane plane point

        displacement =
            Direction3d.times signedDistance plane.normalDirection
    in
        minus displacement point


projectInto : Plane3d -> Point3d -> Point2d
projectInto plane =
    vectorFrom plane.originPoint
        >> Vector3d.projectInto plane
        >> (\(Vector2d x y) -> Point2d x y)


plus : Vector3d -> Point3d -> Point3d
plus (Vector3d vx vy vz) (Point3d px py pz) =
    Point3d (px + vx) (py + vy) (pz + vz)


minus : Vector3d -> Point3d -> Point3d
minus (Vector3d vx vy vz) (Point3d px py pz) =
    Point3d (px - vx) (py - vy) (pz - vz)


toRecord : Point3d -> { x : Float, y : Float, z : Float }
toRecord (Point3d x y z) =
    { x = x, y = y, z = z }


fromRecord : { x : Float, y : Float, z : Float } -> Point3d
fromRecord { x, y, z } =
    Point3d x y z