class CommentPolicy < ApplicationPolicy
  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end

    private

    attr_reader :user, :scope
  end

  def show?
    user.present?
  end

  def create?
    user.present?
  end

  def update?
    user.present? && (record.user == user || record.commentable.user == user)
  end

  def destroy?
    user.present? && (record.user == user || record.commentable.user == user)
  end
end
