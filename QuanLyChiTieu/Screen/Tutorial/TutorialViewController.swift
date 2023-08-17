//
//  TutorialViewController.swift
//  QuanLyChiTieu
//
//  Created by Nguyễn Tuấn on 08/08/2023.
//

import UIKit

struct Tutorial {
    let image: String
}

class TutorialViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var currentPage = 0
    
    private var dataSource = [Tutorial]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        dataSource = [
            Tutorial(image: "Tutorial_1"),
            Tutorial(image: "Tutorial_2"),
            Tutorial(image: "Tutorial_3")
        ]
    }
    
    private func setupCollectionView() {
            collectionView.delegate = self
            collectionView.dataSource = self
            
            //Đăng ký custom collection view cell
            collectionView.register(UINib(nibName: "TutorialCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TutorialCollectionViewCell")
            collectionView.backgroundColor = .white
            
            if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.minimumLineSpacing = 0
                flowLayout.minimumInteritemSpacing = 0
                
                flowLayout.estimatedItemSize = .zero
                flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                flowLayout.scrollDirection = .horizontal
            }
            collectionView.isPagingEnabled = true
            collectionView.showsHorizontalScrollIndicator = false
        }
    
    private func routeToAuthNavigation() {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let navigation = UINavigationController(rootViewController: loginVC)
            navigation.modalPresentationStyle = .fullScreen
            self.present(navigation, animated: true)
            UserDefaults.standard.set(true, forKey: "tutorialCompleted")
        }
}

//MARK: - UICollectionViewDataSource:
extension TutorialViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorialCollectionViewCell", for: indexPath) as! TutorialCollectionViewCell
        let tutorialModel = dataSource[indexPath.row]
        
        cell.bindData(index: indexPath.row,
                      image: tutorialModel.image) { [weak self] in
            guard let self = self else {return}
            if indexPath.row + 1 == self.dataSource.count {
                self.routeToAuthNavigation()
                UserDefaults.standard.set(true, forKey: "tutorialCompleted")
            } else {
                self.currentPage = indexPath.row + 1
                self.collectionView.isPagingEnabled = false
                self.collectionView.scrollToItem(at: IndexPath(row: self.currentPage, section: 0), at: .centeredHorizontally, animated: true)
                self.collectionView.isPagingEnabled = true
            }
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegate:
extension TutorialViewController: UICollectionViewDelegate {
    
}
