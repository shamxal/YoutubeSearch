//
//  SearchController.swift
//  YoutubeTest
//
//  Created by Shamkhal Guliyev on 08.07.22.
//

import UIKit

class SearchController: UIViewController {
    
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var collection: UICollectionView!
    
    let viewModel = SearchViewModel()
    let identifier = "\(SearchCell.self)"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionSetup()
        viewModelConfig()
//        viewModel.getVideos(text: "ronaldo")
    }
    
    fileprivate func collectionSetup() {
        collection.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
    fileprivate func viewModelConfig() {
        viewModel.searchItemtCallback = { [weak self] in
            DispatchQueue.main.async {
                self?.collection.reloadData()
            }
        }
        viewModel.errorCallback = { [weak self] errorMessage in
            self?.present(AlertViewHelper.showAlert(message: errorMessage),
                    animated: true,
                    completion: nil)
        }
    }
    
    fileprivate func getVideos() {
        viewModel.getVideos(text: searchTextField.text ?? "")
    }
}

extension SearchController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        getVideos()
        return true
    }
}

extension SearchController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.searchItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! SearchCell
        cell.configure(data: viewModel.searchItems[indexPath.item].videoUrl ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width * 0.92, height: collectionView.frame.height * 0.25)
    }
}
