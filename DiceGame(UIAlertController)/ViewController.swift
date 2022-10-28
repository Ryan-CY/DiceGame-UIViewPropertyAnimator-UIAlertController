//
//  ViewController.swift
//  DiceGame(UIAlertController)
//
//  Created by Ryan Lin on 2022/10/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var diceImageViews: [UIImageView]!
    @IBOutlet weak var bigSmallSegmentedControl: UISegmentedControl!
    @IBOutlet weak var betSegmentedControl: UISegmentedControl!
    @IBOutlet weak var chipsLabel: UILabel!
    //起初籌碼
    var chips = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for d in 0...2 {
            //隨機呈現點數
            diceImageViews[d].image = UIImage(systemName: "die.face.\(Int.random(in: 1...6)).fill")
            //讓骰子呈45度角
            diceImageViews[d].transform = CGAffineTransform.identity.rotated(by: CGFloat.pi/180 * 45)
            //骰子隨機顏色
            diceImageViews[d].tintColor = UIColor(hue: CGFloat(Double.random(in: 0...1)), saturation: CGFloat(Double.random(in: 0...1)), brightness: CGFloat(Double.random(in: 0...1)), alpha: 1)
        }
        chipsLabel.text = "\(chips) 💸"
    }
    //破產function
    func bankruptcy() {
        chipsLabel.text = "bye💸"
        //設定提醒視窗樣式及內容
        let controller = UIAlertController(title: "LOSE & 破產", message: "要雪恥嗎?", preferredStyle: .actionSheet)
        //新增第一個按鈕選單
        controller.addAction(UIAlertAction(title: "好啊 !", style: .default, handler: { _ in
            //新增提醒視窗
            let getChipsController = UIAlertController(title: "讓彼得潘幫你一把！", message: "輸入 “peterpan” 獲得1500籌碼", preferredStyle: .alert)
            //新增text field到提醒視窗
            getChipsController.addTextField{
                textField in
                textField.placeholder = "peterpan"
            }
            //新增動作按鈕到提醒視窗
            getChipsController.addAction(UIAlertAction(title: "呼叫彼得潘", style: .default, handler: { _ in
                //宣告property儲存輸入的資訊並印出
                let peterpan = getChipsController.textFields?[0].text
                print(peterpan as Any)
                //判斷輸入的訊息是否正確
                if getChipsController.textFields?[0].text == "peterpan" {
                    //填寫完成後 再出現一個確認完成填寫視窗
                    let doneController = UIAlertController(title: "Hooray !", message: "獲得1500籌碼 !", preferredStyle: .alert)
                    doneController.addAction(UIAlertAction(title: "關閉視窗", style: .default, handler: { _ in
                        self.chips = 1500
                        self.chipsLabel.text = "\(self.chips) 💸"
                    }))
                    //用present顯示完成視窗
                    self.present(doneController, animated: true)
                    //若是沒有輸入peterpan
                } else {
                    //新增彈出視窗
                    let remindController = UIAlertController(title: "還未輸入", message: "請輸入peterpan", preferredStyle: .actionSheet)
                    //視窗加一個按鈕
                    remindController.addAction(UIAlertAction(title: "關閉視窗", style: .default))
                    //呈現視窗
                    self.present(remindController, animated: true)
                }
            }))
            //用present顯示視窗
            self.present(getChipsController, animated: true)
        }))
        
        //新增第二個按鈕選單
        controller.addAction(UIAlertAction(title: "讓我想一想🤔", style: .cancel, handler: nil))
        //用present呈現視窗
        self.present(controller, animated: true, completion: nil)
    }
    
    fileprivate func play() {
        if chips > 0 {
            //重置總點數
            var totalPoint = 0
            //設定改變大小隨機的範圍
            let scale = CGFloat.random(in: 1...1.4)
            //設定動畫為1.2秒
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1.2, delay: 0, animations:{
                //用迴圈套用在array骰子Image View上
                for d in 0...2 {
                    for _ in 1...20 {
                        //用CGAffineTransform改變位置，大小及角度
                        self.diceImageViews[d].transform = CGAffineTransform.identity.translatedBy(x: CGFloat.random(in: -15...15), y: CGFloat.random(in: -100...100)).scaledBy(x: scale, y: scale).rotated(by: CGFloat.pi/180 * CGFloat.random(in: -360...360))
                        //讓影像隨機變色
                        self.diceImageViews[d].tintColor = UIColor(hue: CGFloat(Double.random(in: 0...1)), saturation: CGFloat(Double.random(in: 0...1)), brightness: CGFloat(Double.random(in: 0...1)), alpha: 1)
                    }
                }
            }, completion: nil)
            //設定點數隨機變換
            for dice in diceImageViews {
                let point = Int.random(in: 1...6)
                dice.image = UIImage(systemName: "die.face.\(point).fill")
                //三個骰子點數相加
                totalPoint += point
            }
            //用switch判斷結果
            switch bigSmallSegmentedControl.selectedSegmentIndex {
            case 0:
                switch betSegmentedControl.selectedSegmentIndex {
                    //賭小100
                case 0:
                    switch totalPoint {
                    case 3...9:
                        chips += 100
                        chipsLabel.text = "\(chips) 💸"
                        //設定提醒視窗樣式及內容
                        let controller = UIAlertController(title: "YOU WIN !", message: "\(totalPoint)點,加100籌碼", preferredStyle: .alert)
                        //新增動作按鈕
                        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        //新增另一個動作按鈕
                        controller.addAction(UIAlertAction(title: "同樣賭金再玩一次", style: .default, handler: { _ in
                            self.play()
                        }))
                        //用present來顯示提醒視窗
                        present(controller, animated: true, completion: nil)
                    default:
                        chips -= 100
                        chipsLabel.text = "\(chips) 💸"
                        if chips > 0 {
                            let controller = UIAlertController(title: "YOU LOSE !", message: "\(totalPoint)點,減100籌碼", preferredStyle: .alert)
                            controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            controller.addAction(UIAlertAction(title: "同樣賭金再玩一次", style: .default, handler: { _ in
                                self.play()
                            }))
                            present(controller, animated: true, completion: nil)
                            print("small 100 lose")
                        } else {
                            bankruptcy()
                        }
                    }
                    //賭小300
                default:
                    switch totalPoint {
                    case 3...9:
                        chips += 300
                        chipsLabel.text = "\(chips) 💸"
                        let controller = UIAlertController(title: "YOU WIN !", message: "\(totalPoint)點,加300籌碼", preferredStyle: .alert)
                        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        controller.addAction(UIAlertAction(title: "同樣賭金再玩一次", style: .default, handler: { _ in
                            self.play()
                        }))
                        present(controller, animated: true, completion: nil)
                    default:
                        chips -= 300
                        chipsLabel.text = "\(chips) 💸"
                        if chips > 0 {
                            let controller = UIAlertController(title: "YOU LOSE !", message: "\(totalPoint)點,減300籌碼", preferredStyle: .alert)
                            controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            controller.addAction(UIAlertAction(title: "同樣賭金再玩一次", style: .default, handler: { _ in
                                self.play()
                            }))
                            present(controller, animated: true, completion: nil)
                            print("small 300 lose")
                        } else {
                            bankruptcy()
                        }
                    }
                }
            default:
                switch betSegmentedControl.selectedSegmentIndex {
                    //賭大100
                case 0:
                    switch totalPoint {
                    case 10...18:
                        chips += 100
                        chipsLabel.text = "\(chips) 💸"
                        let controller = UIAlertController(title: "YOU WIN !", message: "\(totalPoint)點,加100籌碼", preferredStyle: .alert)
                        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        controller.addAction(UIAlertAction(title: "同樣賭金再玩一次", style: .default, handler: { _ in
                            self.play()
                        }))
                        present(controller, animated: true, completion: nil)
                    default:
                        chips -= 100
                        chipsLabel.text = "\(chips) 💸"
                        if chips > 0 {
                            let controller = UIAlertController(title: "YOU LOSE !", message: "\(totalPoint)點,減100籌碼", preferredStyle: .alert)
                            controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            controller.addAction(UIAlertAction(title: "同樣賭金再玩一次", style: .default, handler: { _ in
                                self.play()
                            }))
                            present(controller, animated: true, completion: nil)
                            print("big 100 lose")
                        } else {
                            bankruptcy()
                        }
                    }
                    //賭大300
                default:
                    switch totalPoint {
                    case 10...18:
                        chips += 300
                        chipsLabel.text = "\(chips) 💸"
                        let controller = UIAlertController(title: "YOU WIN !", message: "\(totalPoint)點,加300籌碼", preferredStyle: .alert)
                        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        controller.addAction(UIAlertAction(title: "同樣賭金再玩一次", style: .default, handler: { _ in
                            self.play()
                        }))
                        present(controller, animated: true, completion: nil)
                    default:
                        chips -= 300
                        chipsLabel.text = "\(chips) 💸"
                        if chips > 0 {
                            let controller = UIAlertController(title: "YOU LOSE !", message: "\(totalPoint)點,減300籌碼", preferredStyle: .alert)
                            controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            controller.addAction(UIAlertAction(title: "同樣賭金再玩一次", style: .default, handler: { _ in
                                self.play()
                            }))
                            present(controller, animated: true, completion: nil)
                            print("big 300 lose")
                        } else {
                            bankruptcy()
                        }
                    }
                }
            }
        } else {
            bankruptcy()
        }
    }
    
    @IBAction func rollButton(_ sender: Any) {
        play()
    }
}
