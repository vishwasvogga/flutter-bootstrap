
class VideoService {
    static final VideoService ourInstance = new VideoService();

    static VideoService getInstance() {
        return ourInstance;
    }

    VideoService() {
    }
}
