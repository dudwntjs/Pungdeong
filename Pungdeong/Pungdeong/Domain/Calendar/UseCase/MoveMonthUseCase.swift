//
//  MoveMonthUseCase.swift
//  Pungdeong
//
//  Created by sun on 3/27/26.
//

protocol MoveMonthUseCase {
    func execute(currentOffset: Int, step: Int) -> Int
}

final class DefaultMoveMonthUseCase: MoveMonthUseCase {
    func execute(currentOffset: Int, step: Int) -> Int {
        currentOffset + step
    }
}
