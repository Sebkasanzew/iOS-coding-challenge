//
//  VoiceListenerViewController
//  WeatherVoice
//
//  Created by Sebastian Kasanzew on 09.09.18.
//  Copyright © 2018 Sebastian Kasanzew. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class VoiceListenerViewController: UIViewController {

    @IBOutlet weak var voiceButton: UIButton!
    
    private let model = VoiceListenerModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.registerVoiceButtonListener()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func registerVoiceButtonListener() {
        self.voiceButton.rx.tap.subscribe( onNext: { event in
            self.model.recordAudio()
            // TODO Add feedback for audio processing
        }).disposed(by: self.disposeBag)
    }

}
