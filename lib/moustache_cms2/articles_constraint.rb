module MoustacheCMS2
  class ArticlesConstraint
    include MoustacheCMS2::RequestCurrentSite

    def matches?(request)
      articles(request).map { |a| a.name }.include?(request.params[:articles] || request.params[:page_path])
    end

    def articles(request)
      @current_site ||= request_current_site(request)
      @article_collections ||= @current_site.article_collections
    end
  end
end
