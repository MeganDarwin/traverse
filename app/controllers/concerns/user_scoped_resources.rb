module UserScopedResources
  extend ActiveSupport::Concern

  included do
    def user_scoped(model_class)
      model_class.for_user(current_user)
    end
  end
end
