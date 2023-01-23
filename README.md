# SwiftyImageCache
Simple Image Cache and Image Downloader using NSCache and URLSession


## Usage
- Use `ImageCache` class and its shared object to get an image for key.
- For e.g.
  
  ``` swift
  ImageCache.shared.fetchImage(for: url) { result in
      // Do image result handling here according to your use case.
  }
  ```

### ImageDownloader
- Class which downloads an image from server with given URL.
- It handles duplicate requests with same URL

### ImageCache
- Data container (wrapper) for image cache.
- Uses NSCache internally.
- If image is cached then it is returned or else makes use of `ImageDownloader` to download it.
