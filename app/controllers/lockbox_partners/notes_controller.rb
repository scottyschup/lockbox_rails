class LockboxPartners::NotesController < ApplicationController
  before_action :find_commentable, only: %w[create]
  before_action :find_note, except: [:create]

  def create
    @note = @commentable.notes.build(note_params.merge(user_id: current_user.id))
    if @note.save
      render json: {
        note: render_to_string(
          partial: 'lockbox_partners/notes/note',
          locals: {
            note: @note
          }
        ),
        text: @note.text
      }
    else
      render json: {
        error: render_to_string(
          partial: 'shared/error',
          locals: {
            key: 'alert',
            value: @note.errors.full_messages.join(', ')
          }
        )
      }
    end
  end

  def show
    render partial: 'lockbox_partners/notes/note', locals: { note: @note }
  end

  def edit
    render 'lockbox_partners/notes/edit', layout: false
  end

  def update
    if @note.update(note_params)
      render json: {
        note: render_to_string(
          partial: 'lockbox_partners/notes/note',
          locals: {
            note: @note
          }
        ),
        text: @note.text
      }
    else
      render json: {
        error: render_to_string(
          partial: 'shared/error',
          locals: {
            key: 'alert',
            value: @note.errors.full_messages.join(', ')
          }
        )
      }
    end
  end

  private

  def note_params
    params.require(:note).permit(:id, :text)
  end

  def find_commentable
    # We need the last two penultimate pieces of the path
    # It's safe to assume that the most specific piece of the path
    # is the commentable item
    resource, id = request.path.split('/').last(3)
    begin
      @commentable = resource.singularize.classify.constantize.find(id)
    rescue ActiveRecord::RecordNotFound
      return head :bad_request
    end
  end

  def find_note
    @note = Note.find(params[:id])
  end
end
