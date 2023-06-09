/// Copyright (c) 2021 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI
import AVKit

struct VideoFeedView: View {
  private let videos = Video.fetchLocalVideos() + Video.fetchRemoteVideos()
  
  private let videoClips = VideoClip.urls
  
  @State private var selectedVideo: Video?
  @State private var embeddedVideoRate: Float = 0.0
  @State private var embeddedVideoVolume: Float = 0.0

  var body: some View {
    NavigationView {
      List {
        makeEmbeddedVideoPlayer()
        ForEach(videos) { video in
          Button {
            selectedVideo = video
          } label: {
            VideoRow(video: video)
          }
        }
      }
      .navigationTitle("Travel Vlogs")
    }
    .fullScreenCover(item: $selectedVideo) {
      // On Dismiss Closure
      embeddedVideoRate = 1.0
    } content: { item in
      makeFullScreenVideoPlayer(for: item)
    }
  }

  private func makeEmbeddedVideoPlayer() -> some View {
    HStack {
      Spacer()
      
      LoopingPlayerView(
        videoURLs: videoClips,
        volume: $embeddedVideoVolume,
        rate: $embeddedVideoRate)
      .onAppear {
        embeddedVideoRate = 0.0
      }
      .onTapGesture(count: 2) {
        embeddedVideoRate = embeddedVideoRate == 1.0 ? 2.0 : 1.0
      }
      .onTapGesture {
        embeddedVideoVolume = embeddedVideoVolume == 1.0 ? 0.0 : 1.0
      }

      Spacer()
    }
  }
  
  @ViewBuilder
  private func makeFullScreenVideoPlayer(for video: Video) -> some View {
    if let url = video.videoURL {
      let avPlayer = AVPlayer(url: url)
      VideoPlayerView(player: avPlayer)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
          avPlayer.play()
        }
    } else {
      ErrorView()
    }
  }
}

struct VideoFeedView_Previews: PreviewProvider {
  static var previews: some View {
    VideoFeedView()
  }
}
