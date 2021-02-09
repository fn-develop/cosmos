class LineRichmenuImageUploader  < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def size_range
    0.001.megabytes..5.megabytes
  end

  def store_dir
    Rails.root.join('uploads', model.class.to_s.underscore, model.id.to_s).to_s
  end

  # 保存するファイルの種類を設定
  def extension_whitelist
    %w(png jpg jpeg gif)
  end

  # ファイル名を指定
  def filename
    "#{ Date.today }-#{ original_filename }"
  end

  def cache_dir
    'cache'
  end

  # サムネイルの為に画像をリサイズ
  version :thumb_240 do
    process resize_to_fit: [240, 81]
  end
end
