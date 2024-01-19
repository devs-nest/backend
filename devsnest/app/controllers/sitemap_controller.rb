# frozen_string_literal: true

class SitemapController < ApplicationController
  def index
    algo_challenges = { url: 'api/v1/challenges', slugs: Challenge.active.pluck(:slug) }
    backend_challenges = { url: 'api/v1/backend_challenges', slugs: BackendChallenge.where(is_active: true).pluck(:slug, :id) }
    frontend_challenges = { url: 'api/v1/frontend_challenges', slugs: FrontendChallenge.where(is_active: true).pluck(:slug, :id, :topic) }
    blogs = { url: '/api/v1/article?resource_type=blog', slugs: Article.where(resource_type: 'blog').pluck(:slug) }
    groups = { url: '/api/v1/groups', slugs: Group.where(group_type: 'public').pluck(:slug) }

    render_success({ algo_challenges: algo_challenges, backend_challenges: backend_challenges, frontend_challenges: frontend_challenges, blogs: blogs, groups: groups })
  end
end
