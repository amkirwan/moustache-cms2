class CommentsController < CmsSiteController

  before_filter :load_page, only: :create

  def create  
    @article = Article.find(params[:article_id])
    @comment = @article.comments.build(params[:comment])
    @comment.request = request
    if @comment.save
      flash[:notice] = "Thanks for the comment." 
      redirect_to request_permalink
    else
      document = MoustacheCMS2::Mustache::CmsPage.new(self).render
      render text: document.clean_html
    end
  end


end
