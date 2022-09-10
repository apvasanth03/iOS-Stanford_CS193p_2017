//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by Vasanthakumar Annadurai on 10/09/22.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController {
    
    let themes = [
        "Sports" : ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🏉", "🎱", "🏓", "🏸", "🥅", "🏒"],
        "Faces" : ["😀", "😃", "😄", "😁", "😆", "😅", "😂", "🤣", "☺️", "😊", "😇", "🙂"],
        "Animals" : ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯", "🦁", "🐮"]
    ]
    // Property returns ConcentrationViewController - If we are currently in SplitViewController.
    private var spiltViewDetailConcentrationViewController: ConcentrationViewController?{
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    private var lastSequedToConcentrationViewController: ConcentrationViewController?
    
    // MARK: - UIViewController Methods.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme"{
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]{
                if let cvc = segue.destination as? ConcentrationViewController{
                    cvc.theme = theme
                    lastSequedToConcentrationViewController = cvc
                }
            }
        }
    }
    
    // MARK: - Action Methods.
    @IBAction func changeTheme(_ sender: Any) {
        // If we are currently in SplitViewController - Then dont't seque (Create new instance) instead just update current CVC.
        if let cvc = spiltViewDetailConcentrationViewController{
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]{
                cvc.theme = theme
            }
        }
            // If we are currently in NavigationViewControler - Then instead of creating new seque (New instance) each time instead keep hold of last CVC instnace & update the theme & push.
        else if let cvc = lastSequedToConcentrationViewController{
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]{
                cvc.theme = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        }
        else{
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
}
