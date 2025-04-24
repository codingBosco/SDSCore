//
//  Meshes.swift
//  SDSCore
//
//  Created by Sese on 05/04/25.
//

import SwiftUI

public struct StudentBackgroundMesh1 {
    let width: Int = 5
    let height: Int = 5
    let points: [SIMD2<Float>] =
        [
            SIMD2<Float>(0.0, 0.0),
            SIMD2<Float>(0.10756366, 0.0),
            SIMD2<Float>(0.43398315, 0.0),
            SIMD2<Float>(0.8018192, 0.0),
            SIMD2<Float>(1.0, 0.0),
            SIMD2<Float>(0.0, 0.16435099),
            SIMD2<Float>(0.24051593, 0.23357219),
            SIMD2<Float>(0.4817658, 0.034838054),
            SIMD2<Float>(0.63377213, 0.23083538),
            SIMD2<Float>(1.0, 0.11678807),
            SIMD2<Float>(0.0, 0.46207696),
            SIMD2<Float>(0.24116895, 0.5632996),
            SIMD2<Float>(0.47924152, 0.67917836),
            SIMD2<Float>(0.7456052, 0.51474977),
            SIMD2<Float>(1.0, 0.43442142),
            SIMD2<Float>(0.0, 0.65160304),
            SIMD2<Float>(0.2753545, 0.70667183),
            SIMD2<Float>(0.561432, 0.57931244),
            SIMD2<Float>(0.899763, 0.74820507),
            SIMD2<Float>(1.0, 0.83142453),
            SIMD2<Float>(0.0, 1.0),
            SIMD2<Float>(0.18414165, 1.0),
            SIMD2<Float>(0.35139272, 1.0),
            SIMD2<Float>(0.7411271, 1.0),
            SIMD2<Float>(1.0, 1.0)
        ]
    let colors: [Color] = [
        Color(red: 0.746, green: 0.692, blue: 0.987),
        Color(red: 0.163, green: 0.534, blue: 0.790),
        Color(red: 0.824, green: 0.760, blue: 0.913),
        Color(red: 0.992, green: 0.397, blue: 0.870),
        Color(red: 0.620, green: 0.025, blue: 0.955),
        Color(red: 0.746, green: 0.692, blue: 0.987),
        Color(red: 0.163, green: 0.534, blue: 0.790),
        Color(red: 0.824, green: 0.760, blue: 0.913),
        Color(red: 0.992, green: 0.397, blue: 0.870),
        Color(red: 0.620, green: 0.025, blue: 0.955),
        Color(red: 0.746, green: 0.692, blue: 0.987),
        Color(red: 0.163, green: 0.534, blue: 0.790),
        Color(red: 0.824, green: 0.760, blue: 0.913),
        Color(red: 0.992, green: 0.397, blue: 0.870),
        Color(red: 0.620, green: 0.025, blue: 0.955),
        Color(red: 0.746, green: 0.692, blue: 0.987),
        Color(red: 0.163, green: 0.534, blue: 0.790),
        Color(red: 0.824, green: 0.760, blue: 0.913),
        Color(red: 0.992, green: 0.397, blue: 0.870),
        Color(red: 0.620, green: 0.025, blue: 0.955),
        Color(red: 0.746, green: 0.692, blue: 0.987),
        Color(red: 0.163, green: 0.534, blue: 0.790),
        Color(red: 0.824, green: 0.760, blue: 0.913),
        Color(red: 0.992, green: 0.397, blue: 0.870),
        Color(red: 0.620, green: 0.025, blue: 0.955)
    ]

    let background: Color = Color(red: 1, green: 1, blue: 1)

    let smoothsColors: Bool = true

    let colorSpace: Gradient.ColorSpace = .device
}

public struct StudentBackgroundMesh2 {
    let width: Int = 5
    let height: Int = 5
    let points: [SIMD2<Float>] = [
        SIMD2<Float>(0.0, 0.0),
        SIMD2<Float>(0.10756366, 0.0),
        SIMD2<Float>(0.43398315, 0.0),
        SIMD2<Float>(0.8018192, 0.0),
        SIMD2<Float>(1.0, 0.0),
        SIMD2<Float>(0.0, 0.16435099),
        SIMD2<Float>(0.24051593, 0.23357219),
        SIMD2<Float>(0.4817658, 0.034838054),
        SIMD2<Float>(0.63377213, 0.23083538),
        SIMD2<Float>(1.0, 0.11678807),
        SIMD2<Float>(0.0, 0.46207696),
        SIMD2<Float>(0.24116895, 0.5632996),
        SIMD2<Float>(0.47924152, 0.67917836),
        SIMD2<Float>(0.7456052, 0.51474977),
        SIMD2<Float>(1.0, 0.43442142),
        SIMD2<Float>(0.0, 0.65160304),
        SIMD2<Float>(0.2753545, 0.70667183),
        SIMD2<Float>(0.561432, 0.57931244),
        SIMD2<Float>(0.899763, 0.74820507),
        SIMD2<Float>(1.0, 0.83142453),
        SIMD2<Float>(0.0, 1.0),
        SIMD2<Float>(0.18414165, 1.0),
        SIMD2<Float>(0.35139272, 1.0),
        SIMD2<Float>(0.7411271, 1.0),
        SIMD2<Float>(1.0, 1.0)
    ]
    let colors: [Color] = [
        Color(red: 0.824, green: 0.760, blue: 0.913),
        Color(red: 0.824, green: 0.760, blue: 0.913),
        Color(red: 0.620, green: 0.025, blue: 0.955),
        Color(red: 0.620, green: 0.025, blue: 0.955),
        Color(red: 0.824, green: 0.760, blue: 0.913),
        Color(red: 0.824, green: 0.760, blue: 0.913),
        Color(red: 0.824, green: 0.760, blue: 0.913),
        Color(red: 0.163, green: 0.534, blue: 0.790),
        Color(red: 0.746, green: 0.692, blue: 0.987),
        Color(red: 0.163, green: 0.534, blue: 0.790),
        Color(red: 0.824, green: 0.760, blue: 0.913),
        Color(red: 0.163, green: 0.534, blue: 0.790),
        Color(red: 0.824, green: 0.760, blue: 0.913),
        Color(red: 0.992, green: 0.397, blue: 0.872),
        Color(red: 0.992, green: 0.397, blue: 0.872),
        Color(red: 0.620, green: 0.025, blue: 0.955),
        Color(red: 0.620, green: 0.025, blue: 0.955),
        Color(red: 0.824, green: 0.760, blue: 0.913),
        Color(red: 0.824, green: 0.760, blue: 0.913),
        Color(red: 0.620, green: 0.025, blue: 0.955),
        Color(red: 0.163, green: 0.534, blue: 0.790),
        Color(red: 0.992, green: 0.397, blue: 0.872),
        Color(red: 0.620, green: 0.025, blue: 0.955),
        Color(red: 0.824, green: 0.760, blue: 0.913),
        Color(red: 0.746, green: 0.692, blue: 0.987)
    ]
    let background: Color = Color(red: 1, green: 1, blue: 1)
    let smoothsColors: Bool = true
    let colorSpace: Gradient.ColorSpace = .device
}

public struct StudentBackgroundMesh3 {
    let width: Int = 5
    let height: Int = 5
    let points: [SIMD2<Float>] =
        [
            SIMD2<Float>(0.0, 0.0),
            SIMD2<Float>(0.10756366, 0.0),
            SIMD2<Float>(0.43398315, 0.0),
            SIMD2<Float>(0.8018192, 0.0),
            SIMD2<Float>(1.0, 0.0),
            SIMD2<Float>(0.0, 0.16435099),
            SIMD2<Float>(0.24051593, 0.23357219),
            SIMD2<Float>(0.4817658, 0.034838054),
            SIMD2<Float>(0.63377213, 0.23083538),
            SIMD2<Float>(1.0, 0.11678807),
            SIMD2<Float>(0.0, 0.46207696),
            SIMD2<Float>(0.24116895, 0.5632996),
            SIMD2<Float>(0.47924152, 0.67917836),
            SIMD2<Float>(0.7456052, 0.51474977),
            SIMD2<Float>(1.0, 0.43442142),
            SIMD2<Float>(0.0, 0.65160304),
            SIMD2<Float>(0.2753545, 0.70667183),
            SIMD2<Float>(0.561432, 0.57931244),
            SIMD2<Float>(0.899763, 0.74820507),
            SIMD2<Float>(1.0, 0.83142453),
            SIMD2<Float>(0.0, 1.0),
            SIMD2<Float>(0.18414165, 1.0),
            SIMD2<Float>(0.35139272, 1.0),
            SIMD2<Float>(0.7411271, 1.0),
            SIMD2<Float>(1.0, 1.0)
        ]
    let colors: [Color] =
        [
            Color(red: 0.792, green: 0.334, blue: 0.999),
            Color(red: 0.792, green: 0.334, blue: 0.999),
            Color(red: 0.156, green: 0.117, blue: 0.958),
            Color(red: 0.464, green: 0.434, blue: 0.879),
            Color(red: 0.156, green: 0.117, blue: 0.958),
            Color(red: 0.792, green: 0.334, blue: 0.999),
            Color(red: -0.252, green: 0.792, blue: 0.774),
            Color(red: 0.653, green: 0.764, blue: 0.915),
            Color(red: 0.464, green: 0.434, blue: 0.879),
            Color(red: 0.156, green: 0.117, blue: 0.958),
            Color(red: 0.653, green: 0.764, blue: 0.915),
            Color(red: 0.792, green: 0.334, blue: 0.999),
            Color(red: 0.792, green: 0.334, blue: 0.999),
            Color(red: 0.792, green: 0.334, blue: 0.999),
            Color(red: 0.653, green: 0.764, blue: 0.915),
            Color(red: 0.653, green: 0.764, blue: 0.915),
            Color(red: 0.464, green: 0.434, blue: 0.879),
            Color(red: 0.156, green: 0.117, blue: 0.958),
            Color(red: -0.252, green: 0.792, blue: 0.774),
            Color(red: -0.252, green: 0.792, blue: 0.774),
            Color(red: 0.792, green: 0.334, blue: 0.999),
            Color(red: 0.464, green: 0.434, blue: 0.879),
            Color(red: 0.464, green: 0.434, blue: 0.879),
            Color(red: 0.464, green: 0.434, blue: 0.879),
            Color(red: 0.156, green: 0.117, blue: 0.958)
        ]
    let background: Color = Color(red: 1, green: 1, blue: 1)
    let smoothsColors: Bool = true
    let colorSpace: Gradient.ColorSpace = .device

}

public struct StudentBackgroundMesh4 {
    let width: Int = 5
    let height: Int = 5
    let points: [SIMD2<Float>] =
        [
            SIMD2<Float>(0.0, 0.0),
            SIMD2<Float>(0.10756366, 0.0),
            SIMD2<Float>(0.43398315, 0.0),
            SIMD2<Float>(0.8018192, 0.0),
            SIMD2<Float>(1.0, 0.0),
            SIMD2<Float>(0.0, 0.16435099),
            SIMD2<Float>(0.24051593, 0.23357219),
            SIMD2<Float>(0.4817658, 0.034838054),
            SIMD2<Float>(0.63377213, 0.23083538),
            SIMD2<Float>(1.0, 0.11678807),
            SIMD2<Float>(0.0, 0.46207696),
            SIMD2<Float>(0.24116895, 0.5632996),
            SIMD2<Float>(0.47924152, 0.67917836),
            SIMD2<Float>(0.7456052, 0.51474977),
            SIMD2<Float>(1.0, 0.43442142),
            SIMD2<Float>(0.0, 0.65160304),
            SIMD2<Float>(0.2753545, 0.70667183),
            SIMD2<Float>(0.561432, 0.57931244),
            SIMD2<Float>(0.899763, 0.74820507),
            SIMD2<Float>(1.0, 0.83142453),
            SIMD2<Float>(0.0, 1.0),
            SIMD2<Float>(0.18414165, 1.0),
            SIMD2<Float>(0.35139272, 1.0),
            SIMD2<Float>(0.7411271, 1.0),
            SIMD2<Float>(1.0, 1.0)
        ]
    let colors: [Color] =
        [
            Color(red: 0.747, green: 0.683, blue: 0.987),
            Color(red: 0.747, green: 0.683, blue: 0.987),
            Color(red: 0.988, green: 0.454, blue: 0.630),
            Color(red: 0.988, green: 0.454, blue: 0.630),
            Color(red: 0.747, green: 0.683, blue: 0.987),
            Color(red: 0.988, green: 0.454, blue: 0.630),
            Color(red: 1, green: -0.169, blue: 0.791),
            Color(red: 0.988, green: 0.454, blue: 0.630),
            Color(red: 0.747, green: 0.683, blue: 0.987),
            Color(red: 0.988, green: 0.454, blue: 0.630),
            Color(red: 1, green: 0.748, blue: 0.910),
            Color(red: 1, green: -0.169, blue: 0.791),
            Color(red: 0.988, green: 0.454, blue: 0.630),
            Color(red: 0.747, green: 0.683, blue: 0.987),
            Color(red: 1, green: 0.748, blue: 0.910),
            Color(red: 1, green: 0.748, blue: 0.910),
            Color(red: 0.988, green: 0.454, blue: 0.630),
            Color(red: 0.988, green: 0.454, blue: 0.630),
            Color(red: 0.988, green: 0.454, blue: 0.630),
            Color(red: 1, green: -0.169, blue: 0.791),
            Color(red: 0.383, green: 0.695, blue: 0.867),
            Color(red: 1, green: -0.169, blue: 0.791),
            Color(red: 0.988, green: 0.454, blue: 0.630),
            Color(red: 0.383, green: 0.695, blue: 0.867),
            Color(red: 1, green: -0.169, blue: 0.791)
        ]
    let background: Color = Color(red: 1, green: 1, blue: 1)
    let smoothsColors: Bool = true
    let colorSpace: Gradient.ColorSpace = .device

}

    public var studentMesh1: MeshGradient {
        
        let mesh = StudentBackgroundMesh1()
        
        return MeshGradient(
            width: mesh.width,
            height: mesh.height,
            points: mesh.points,
            colors: mesh.colors,
            background: mesh.background,
            smoothsColors: mesh.smoothsColors,
            colorSpace: mesh.colorSpace
        )
    }

    public var studentMesh2: MeshGradient {
        
        let mesh = StudentBackgroundMesh2()
        return MeshGradient(
            width: mesh.width,
            height: mesh.height,
            points: mesh.points,
            colors: mesh.colors,
            background: mesh.background,
            smoothsColors: mesh.smoothsColors,
            colorSpace: mesh.colorSpace
        )
        
    }

    public var studentMesh3: MeshGradient {
        
        let mesh = StudentBackgroundMesh3()
        return MeshGradient(
            width: mesh.width,
            height: mesh.height,
            points: mesh.points,
            colors: mesh.colors,
            background: mesh.background,
            smoothsColors: mesh.smoothsColors,
            colorSpace: mesh.colorSpace
        )
        
    }

    public var studentMesh4: MeshGradient {
        
        let mesh = StudentBackgroundMesh4()
        return MeshGradient(
            width: mesh.width,
            height: mesh.height,
            points: mesh.points,
            colors: mesh.colors,
            background: mesh.background,
            smoothsColors: mesh.smoothsColors,
            colorSpace: mesh.colorSpace
        )
        
    }


public let studentMeshes: [MeshGradient] = [
    studentMesh1,
    studentMesh2,
    studentMesh3,
    studentMesh4
]
