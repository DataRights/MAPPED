require 'tempfile'
require 'test_helper'

class AttachmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @attachment = attachments(:one)
  end

  test "should get index" do
    get attachments_url
    assert_response :success
  end

  test "should get new" do
    get new_attachment_url
    assert_response :success
  end

  test "should create attachment" do
    assert_difference('Attachment.count') do
      post attachments_url, params: { attachment: { title: 'A new attachment', workflow_transition_id: WorkflowTransition.first.id} }
    end

    assert_redirected_to attachment_url(Attachment.last)
  end

  test "should show attachment" do
    get attachment_url(@attachment)
    assert_response :success
  end

  test "should get edit" do
    get edit_attachment_url(@attachment)
    assert_response :success
  end

  test "should update attachment" do
    patch attachment_url(@attachment), params: { attachment: { title: 'Updated attachment' } }
    assert_redirected_to attachment_url(@attachment)
  end

  test "should destroy attachment" do
    assert_difference('Attachment.count', -1) do
      delete attachment_url(@attachment)
    end

    assert_redirected_to attachments_url
  end

  test "should get attachment content" do
    get get_content_path(@attachment), xhr: true
    assert_response :success
    assert_equal '{}', response.body
    @attachment.content = 'test'
    @attachment.save!
    get get_content_path(@attachment), xhr: true
    assert_equal 'test', response.body
  end

  test "should post attachment content" do
    image_file = fixture_file_upload('files/Testing.jpg','image/jpeg')
    post post_content_path(@attachment), params: {image: image_file}
    assert_response :success
    assert_equal '{}', response.body
    @attachment.reload
    assert_equal @attachment.content, image_file.tempfile.read
  end

  test "should create new attachment by posting new content" do
    image_file = fixture_file_upload('files/Testing.jpg','image/jpeg')

    assert_difference('Attachment.count') do
      post new_content_path, params: {image: image_file, workflow_transition_id: WorkflowTransition.first.id}
    end
  end

  test 'should return thumbnail' do
    image_file = file_fixture('Testing.jpg')
    @attachment.content = image_file.read
    @attachment.save!
    get thumbnail_path(@attachment)
    assert_response :success
    assert_equal @attachment.content_type, response.content_type
  end

end
