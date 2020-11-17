class PublicImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def size_range
    0.001.megabytes..5.megabytes
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # 保存するファイルの種類を設定
  def extension_whitelist
    %w(png jpg jpeg pdf gif)
  end

  # ファイル名を指定
  def filename
    "#{ Date.today }-#{ original_filename }"
  end

  def cache_dir
    'cache'
  end

  # def root
  #   "#{ Rails.root }/tmp"
  # end

  # サムネイルの為に画像をリサイズ
  version :thumb_220 do
    process resize_to_fit: [220, 220]
  end

  # サムネイルの為に画像をリサイズ
  version :thumb_50 do
    process resize_to_fit: [50, 50]
  end
end
