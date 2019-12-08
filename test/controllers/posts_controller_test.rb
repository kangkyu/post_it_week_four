require "test_helper"

class PostsControllerTest < ActionController::TestCase

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session[:user_id] = nil
  end

  class NeedNotAuthenticate < PostsControllerTest

    def test_get_index
      get :index
      assert_response :success
    end

    def test_get_show
      get :show, params: { id: posts(:one) }
      assert_response :success
    end
  end

  class NeedAuthenticate < PostsControllerTest

    def test_get_new
      log_in users(:one)
      get :new
      assert_response :success
    end

    def test_post_create
      log_in users(:one)
      assert_difference 'Post.count' do
        post :create, params: {
          post: posts(:one).attributes
          .merge(categories: [categories(:two), categories(:four)])
        }
      end
    end
  end

  class NeedAuthorize < PostsControllerTest

    def test_delete_destroy
      log_in posts(:one).user
      assert_difference 'Post.count', -1 do
        delete :destroy, params: {
          id: posts(:one).to_param
        }
      end
    end

    def test_get_edit
      log_in users(:one)
      get :edit, params: {
        id: posts(:one)
      }
      assert_response :success
      assert_template 'posts/edit'
    end

    def test_patch_update
      log_in users(:one)
      original_post     = users(:one).posts.first

      new_post_hash = original_post.attributes
      new_post_hash["title"] = "updated title"
      new_post_category_ids = [categories(:one).id, categories(:three).id].sort

      assert_no_difference 'Post.count' do
        patch :update, params: {
          id: original_post.to_param, post: new_post_hash
          .merge(category_ids: new_post_category_ids)
        }
      end
      assert_equal "updated title", users(:one).posts.first.title
      assert_equal new_post_category_ids, users(:one).posts.first.category_ids

      assert_response :redirect
      assert_not_nil assigns(:post)
      assert_equal "updated title", assigns(:post).title
      assert_equal new_post_category_ids, assigns(:post).category_ids
    end
  end

  class NotAuthenticated < PostsControllerTest

    def test_get_new_not_authenticated
      log_out
      get :new
      assert_response :redirect
    end

    def test_post_create_not_authenticated
      log_out
      assert_no_difference 'Post.count' do
        post :create, params: {
          post: posts(:one).attributes
          .merge(categories: [categories(:two), categories(:four)])
        }
      end
    end

    def test_delete_destroy_not_authenticated
      log_out
      assert_no_difference 'Post.count' do
        delete :destroy, params: { id: posts(:one).id }
      end
    end

    def test_post_edit_not_authenticated
      log_out
      get :edit, params: { id: posts(:one) }
      assert_response :redirect
      assert_redirected_to '/login'
    end

    def test_patch_update_not_authenticated
      log_out
      new_post_hash = posts(:one).attributes
      new_post_hash["title"] = "updated title"
      new_post_category_ids = [categories(:one).id, categories(:three).id].sort

      assert_no_difference 'Post.count' do
        patch :update, params: {
          id: posts(:one).id, post: new_post_hash
          .merge(category_ids: new_post_category_ids)
        }
      end
      assert_not_equal "updated title", posts(:one).title
      assert_not_equal new_post_category_ids, posts(:one).category_ids

      assert_response :redirect
    end
  end

  class NotAuthorized < PostsControllerTest

    def test_delete_destroy_not_authorized
      log_in users(:one)
      post_another_user_added = users(:two).posts.first

      assert_no_difference 'Post.count' do
        delete :destroy, params: { id: post_another_user_added.id }
      end
    end

    def test_post_edit_not_authorized
      log_in users(:two)
      get :edit, params: { id: users(:one).posts.first }
      assert_response :success
      assert_template 'posts/show'
    end

    def test_patch_update_not_authorized
      log_in users(:one)
      original_post = users(:two).posts.first

      new_post_hash = original_post.attributes
      new_post_hash["title"] = "updated title"
      new_post_category_ids = [categories(:one).id, categories(:three).id].sort

      assert_no_difference 'Post.count' do
        patch :update, params: {
          id: original_post.to_param, post: new_post_hash
          .merge(category_ids: new_post_category_ids)
        }
      end
      assert_not_equal "updated title", users(:two).posts.first.title
      assert_not_equal new_post_category_ids, users(:two).posts.first.category_ids

      assert_response :success
      assert_not_nil assigns(:post)
      assert_not_equal "updated title", assigns(:post).title
      assert_not_equal new_post_category_ids, assigns(:post).category_ids
    end
  end
end
