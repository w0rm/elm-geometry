{- This Source Code Form is subject to the terms of the Mozilla Public License,
   v. 2.0. If a copy of the MPL was not distributed with this file, you can
   obtain one at http://mozilla.org/MPL/2.0/.

   Copyright 2016 by Ian Mackenzie
   ian.e.mackenzie@gmail.com
-}


module Point3d exposing (suite)

import Test exposing (Test)
import Test.Runner.Html as Html
import OpenSolid.Point3d as Point3d
import OpenSolid.Fuzz as Fuzz
import OpenSolid.Fuzz.Point3d as Fuzz
import OpenSolid.Fuzz.Axis3d as Fuzz
import OpenSolid.Expect as Expect
import OpenSolid.Expect.Point3d as Expect
import Generic


rotationAboutAxisPreservesDistance : Test
rotationAboutAxisPreservesDistance =
    let
        description =
            "Rotation about axis preserves distance along that axis"

        expectation point axis angle =
            let
                distance =
                    Point3d.signedDistanceAlong axis point

                rotatedPoint =
                    Point3d.rotateAround axis angle point

                rotatedDistance =
                    Point3d.signedDistanceAlong axis rotatedPoint
            in
                Expect.approximately distance rotatedDistance
    in
        Test.fuzz3 Fuzz.point3d Fuzz.axis3d Fuzz.scalar description expectation


jsonRoundTrips : Test
jsonRoundTrips =
    Generic.jsonRoundTrips Fuzz.point3d Point3d.encode Point3d.decoder


suite : Test
suite =
    Test.describe "OpenSolid.Core.Point3d"
        [ rotationAboutAxisPreservesDistance
        , jsonRoundTrips
        ]


main : Program Never
main =
    Html.run suite