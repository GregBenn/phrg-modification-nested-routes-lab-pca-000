# frozen_string_literal: true

class SongsController < ApplicationController
  def index
    if params[:artist_id]
      if artist.nil?
        redirect_to artists_path, alert: artist_alert
      else
        @songs = artist.songs
      end
    else
      @songs = Song.all
    end
  end

  def show
    if params[:artist_id]
      @song = find_artist_song
      redirect_to artist_songs_path(artist), alert: song_alert if @song.nil?
    else
      @song = song
    end
  end

  def new
    if params[:artist_id] && !Artist.exists?(params[:artist_id])
      redirect_to artists_path, alert: artist_alert
    else
      @song = Song.new(artist_id: params[:artist_id])
    end
  end

  def create
    song = Song.new(song_params)

    if song.save
      redirect_to song
    else
      render :new
    end
  end

  def edit
    if params[:artist_id]
      if artist.nil?
        redirect_to artists_path, alert: artist_alert
      else
        @song = find_artist_song
        redirect_to artist_songs_path(artist), alert: song_alert if @song.nil?
        # if @song.nil?
        #   redirect_to(
        #     artist_songs_path(artist), alert: "Song not found."
        #   )
        # end
      end
    else
      @song = song
    end
  end

  def update
    song.update(song_params)

    if song.save
      redirect_to song
    else
      render :edit
    end
  end

  def destroy
    song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

private

  def song_params
    params.require(:song).permit(:title, :artist_name, :artist_id)
  end

  def song
    @song ||= Song.find(params[:id])
  end

  def artist
    @artist ||= Artist.find_by(id: params[:artist_id])
  end

  def find_artist_song
    artist.songs.find_by(id: params[:id])
  end

  def song_alert
    "Song not found."
  end

  def artist_alert
    "Artist not found."
  end
end
