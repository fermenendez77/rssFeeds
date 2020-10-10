//
//  ArticlesFeedsPresenter.swift
//  RSSReader
//
//  Created by Fernando Menendez on 10/10/2020.
//

import Foundation

protocol ArticlesFeedsPresenter {
    
    init(view : ArticlesFeedsView, selectedRSS : RSSFeeds)
    var articles : [Article] { get set }
    func viewDidLoad()
    func configure(cell : ArticlesTableViewCell, at indexPath: IndexPath)
}

class ArticlesFeedsPresenterImp : ArticlesFeedsPresenter {
    
    weak var view : ArticlesFeedsView?
    var selectedRSS : RSSFeeds
    var articles: [Article] = []
    
    required init(view: ArticlesFeedsView, selectedRSS : RSSFeeds) {
        self.view = view
        self.selectedRSS = selectedRSS
    }
    
    func viewDidLoad() {
        fetchData()
    }
    
    func configure(cell: ArticlesTableViewCell, at indexPath: IndexPath) {
        let article = articles[indexPath.row]
        cell.configure(url: article.url)
        cell.configure(title: article.title)
        cell.configure(date: article.date)
    }
    
    
    func fetchData() {
        guard let token = UserSession.getUserToken() else {
            return
        }
        let restClient = RestClientService(urlBase: "167.99.162.146")
        let endPoint = "/feeds/\(selectedRSS.id)/articles"
        restClient.dataRequest(endpoint: endPoint,
                               method: .GET,
                               token: token,
                               returnType: RSSArticlesResponse.self,
                               completionHandler: { [weak self] response in
                                guard let strongSelf = self else {
                                    return
                                }
                                strongSelf.articles = response.articles
                                strongSelf.view?.showData()
                               },
                               errorHandler: { [weak self] error in
                                
                               })
    }
}
