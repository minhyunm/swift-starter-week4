//
//  FitnessCenter.swift
//  CodeStarterCamp_Week4
//
//  Created by mingmac on 2022/05/10.
//

import Foundation

class FitnessCenter {
    let centerName: String
    var goalBodyCondition: BodyCondition = BodyCondition(upperBodyMuscleStrength: 0, lowerBodyMuscleStrength: 0, muscularEndurance: 0, tiredness: 0)
    var member: Person?
    let routineList: [Routine]
    
    init(centerName: String, routineList: [Routine]) {
        self.centerName = centerName
        self.routineList = routineList
    }
    
    func receiveNumber() throws -> Int {
        guard let inputNumber = readLine(), let inputNumber = Int(inputNumber) else {
            throw InputError.notInt
        }
        return inputNumber
    }
    
    func receiveString() throws -> String {
        guard let inputName = readLine(), inputName.isEmpty == false, inputName.contains(" ") == false else {
            throw InputError.notString
            }
        for inputValue in inputName {
            guard inputValue.isLetter else {
                throw InputError.notString
            }
        }
        return inputName
    }
    
    func startProcess() throws {
        if let member = member {
            while true {
                do {
                    try member.exercise(routines: chooseRoutine(from: routineList), for: countSetsReapeat())
                    try printResultAfterRoutine()
                    break
                } catch FitnessCenterError.unreachedGoal {
                    print("--------------------")
                    print("목표치에 도달하지 못 했습니다. 현재 \(member.name)님의 컨디션은 다음과 같습니다.")
                    member.bodyCondition.printMucleStatus()
                } catch FitnessCenterError.runAwayMember {
                    print("--------------------")
                    print("\(member.name)님의 피로도가 \(member.bodyCondition.tiredness)입니다. 회원님이 도망갔습니다.")
                    break
                } catch {
                    print("에러메시지를 확인해주세요. \(error)")
                    break
                }
            }
        }
    }
    
    func printResultAfterRoutine() throws {
        if let member = member {
            guard member.bodyCondition.upperBodyMuscleStrength >= goalBodyCondition.upperBodyMuscleStrength,
                  member.bodyCondition.lowerBodyMuscleStrength >= goalBodyCondition.lowerBodyMuscleStrength,
                  member.bodyCondition.muscularEndurance >= goalBodyCondition.muscularEndurance else {
                throw FitnessCenterError.unreachedGoal
            }
            print("--------------------")
            print("성공입니다! 현재 \(member.name)님의 컨디션은 다음과 같습니다.")
            member.bodyCondition.printMucleStatus()
        }
    }
    
    func registerMember() {
        print("안녕하세요 \(centerName) 피트니스 센터 입니다. 회원님의 이름을 알려주세요.")
        while true {
            do {
                member = Person(name: try receiveString(), bodyCondition: BodyCondition(upperBodyMuscleStrength: 0, lowerBodyMuscleStrength: 0, muscularEndurance: 0, tiredness: 0))
                break
            } catch InputError.notString {
                print("한글 또는 영문으로 입력해주세요.")
            } catch {
                print("에러메시지를 확인해주세요. \(error)")
            }
        }
    }
    
    func changeGoalBodyCondition(GoalConditionPart: Int, goalStatus: Int) {
        switch GoalConditionPart {
        case goalBodyCondition.upperBodyMuscleStrength:
            goalBodyCondition.upperBodyMuscleStrength += goalStatus
        case goalBodyCondition.lowerBodyMuscleStrength:
            goalBodyCondition.lowerBodyMuscleStrength += goalStatus
        case goalBodyCondition.muscularEndurance:
            goalBodyCondition.muscularEndurance += goalStatus
        case member?.bodyCondition.tiredness:
            member?.bodyCondition.tiredness += goalStatus
        default:
            return
        }
    }
    
    func selectGoalBodyCondition() {
        print("--------------------")
        print("운동 목표치를 순서대로 알려주세요. 예시) 상체근력: 130, 하체근력: 120, 근지구력: 150")
        while true {
            do {
                print("상체근력 : ", terminator: "")
                changeGoalBodyCondition(GoalConditionPart: goalBodyCondition.upperBodyMuscleStrength, goalStatus: try receiveNumber())
                print("하체근력 : ", terminator: "")
                changeGoalBodyCondition(GoalConditionPart: goalBodyCondition.lowerBodyMuscleStrength, goalStatus: try receiveNumber())
                print("근지구력 : ", terminator: "")
                changeGoalBodyCondition(GoalConditionPart: goalBodyCondition.muscularEndurance, goalStatus: try receiveNumber())
                break
            } catch InputError.notInt {
                print("숫자로 입력해주세요.")
            } catch {
                print("에러메시지를 확인해주세요. \(error)")
            }
        }
        print("현재 피로도를 0에서 100 사이의 숫자로 알려주세요!")
        while true {
            do {
                print("현재 피로도 : ", terminator: "")
                if let member = member {
                    changeGoalBodyCondition(GoalConditionPart: member.bodyCondition.tiredness, goalStatus: try receiveNumber())
                    break
                }
            } catch InputError.notInt {
                print("숫자로 입력해주세요.")
            } catch {
                print("에러메시지를 확인해주세요. \(error)")
            }
        }
    }
    
    func chooseRoutine(from routineList: [Routine]) -> Routine {
        while true {
            do {
                print("--------------------")
                print("몇 번째 루틴으로 하시겠어요?")
                for (index, routine) in routineList.enumerated() {
                    print("\(index + 1). \(routine.name)")
                }
                let index = try receiveNumber() - 1
                
                guard routineList.indices.contains(index) else {
                    throw FitnessCenterError.invaildRoutine
                }
                return routineList[index]
            } catch FitnessCenterError.invaildRoutine {
                print("선택한 루틴이 없습니다.")
            } catch InputError.notInt {
                print("숫자로 입력해주세요.")
            } catch {
                print("에러메시지를 확인해주세요. \(error)")
            }
        }
    }
    
    func countSetsReapeat() -> Int {
        while true {
            do {
                print("--------------------")
                print("몇 세트 반복 하시겠어요?")
                let setCounter = try receiveNumber()
                return setCounter
            } catch InputError.notInt {
                print("숫자로 입력해주세요.")
            } catch {
                print("에러메시지를 확인해주세요. \(error)")
            }
        }
    }
    
    func startForTotalProcess() {
        registerMember()
        selectGoalBodyCondition()
            do {
                try startProcess()
            } catch {
                print("에러메시지를 확인해주세요. \(error)")
            }
        }
}
