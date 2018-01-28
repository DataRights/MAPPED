class AttachmentsController < ApplicationController
  before_action :set_attachment, only: [:show, :edit, :update, :destroy, :get_content, :post_content, :thumbnail]

  before_action :authenticate_user!

  THUMBNAIL_SIZE = 100
  # GET /attachments
  # GET /attachments.json
  def index
    @attachments = Attachment.joins(workflow_transition: {workflow: :access_request}).where(access_requests: {user_id: current_user.id}).all
  end

  # GET /attachments/1
  # GET /attachments/1.json
  def show
  end

  # GET /attachments/1/edit
  def edit
  end

  # PATCH/PUT /attachments/1
  # PATCH/PUT /attachments/1.json
  def update
    respond_to do |format|
      if @attachment.update(attachment_params)
        format.html { redirect_to @attachment, notice: 'Attachment was successfully updated.' }
        format.json { render :show, status: :ok, location: @attachment }
      else
        format.html {

          if @attachment.errors.any?
            errors = '<ul>'
            @attachment.errors.full_messages.each do |message|
              errors = "#{errors}<li>#{message}</li>"
            end
            errors = '</ul>'
            flash[:alert] = errors
          end
          render :edit
        }
        format.json { render json: {success: false, errors: @attachment.errors}, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attachments/1
  # DELETE /attachments/1.json
  def destroy
    @attachment.destroy
    respond_to do |format|
      format.html { redirect_to attachments_url, notice: 'Attachment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_content
    if @attachment && @attachment.content
      send_data @attachment.content, :filename => "Attachment-#{@attachment.id}-#{@attachment.workflow_transition.workflow.access_request.organization.name}", :type => @attachment.content_type
    else
      render json: {}, status: :ok
    end
  end

  def post_content
    @attachment.title = params['image'].original_filename
    @attachment.content_type = params['image'].content_type
    @attachment.content = params['image'].tempfile.read
    if @attachment.save
      render json: { success: true, error: ''}, status: :ok
    else
      render json: { success: false, error: @attachment.errors}, status: :ok
    end
  end

  def thumbnail
    if @attachment && @attachment.content
      geom = "#{THUMBNAIL_SIZE}x#{THUMBNAIL_SIZE}"
      image = Magick::Image.from_blob(@attachment.content).first
      image.change_geometry!(geom) { |cols, rows| image.thumbnail! cols, rows }

      bg = Magick::Image.new(THUMBNAIL_SIZE+6, THUMBNAIL_SIZE+6) { self.background_color = 'gray75' }
      bg = bg.raise(3,3)

      thumbnail = image.composite(bg, Magick::CenterGravity, Magick::DstOverCompositeOp)

      send_data thumbnail.to_blob, :type => @attachment.content_type
    else
      send_data '', :type => ''
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attachment
      a = Attachment.find(params[:id])
      if a.workflow_transition.workflow.access_request.user_id == current_user.id
        @attachment = a
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def attachment_params
      params.require(:attachment).permit(:title, :content_type, :workflow_transition_id)
    end

end
