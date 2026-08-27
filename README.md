# DaQuiz

Hệ thống thi trắc nghiệm trực tuyến dành cho giáo viên và học sinh, xây dựng theo phong cách hiện đại, responsive và dễ sử dụng trên máy tính, máy tính bảng và điện thoại.

## Tính năng chính

### Dành cho giáo viên

- Đăng ký và đăng nhập bằng tài khoản Supabase Auth.
- Dashboard tổng quan sau khi đăng nhập.
- Quản lý ngân hàng câu hỏi.
- Hỗ trợ ba loại câu hỏi:
  - Single choice: chọn một đáp án.
  - Multiple choice: chọn nhiều đáp án.
  - True/False: đúng hoặc sai.
- Thêm, sửa, xóa, tìm kiếm và lọc câu hỏi theo chủ đề hoặc loại câu hỏi.
- Gán điểm cho câu hỏi.
- Nhập câu hỏi hàng loạt từ Word.
- Tạo câu hỏi bằng AI.
- Tải hình minh họa cho câu hỏi.
- Tạo bài kiểm tra với các tùy chọn:
  - Mã bài thi.
  - Thời gian làm bài.
  - Thời gian mở và đóng bài.
  - Tổng điểm.
  - Số lần làm tối đa.
  - Xáo trộn câu hỏi và đáp án.
  - Cho phép hoặc không cho phép xem đáp án sau khi nộp.
- Chế độ thi nghiêm túc:
  - Theo dõi chuyển tab hoặc thu nhỏ cửa sổ.
  - Chặn sao chép và dán.
  - Chặn chuột phải.
  - Chặn một số phím tắt và DevTools.
  - Hỗ trợ chế độ toàn màn hình.
- Xem kết quả và thống kê theo từng bài thi.
- Xem ma trận đúng/sai theo từng câu hỏi.
- Xem điểm trung bình, điểm cao nhất, phổ điểm và thời gian làm bài.
- Xuất bảng điểm Excel và PDF.
- Bảng xếp hạng trực tiếp.
- Battle Realtime.
- Nhập điểm trừ khi học sinh vi phạm.

### Dashboard giáo viên

Dashboard là màn hình mặc định sau khi đăng nhập, gồm:

- Tổng số câu hỏi trong ngân hàng.
- Tổng số bài kiểm tra.
- Số bài kiểm tra đang mở.
- Tổng lượt nộp bài.
- Các thao tác nhanh: thêm câu hỏi, tạo bài thi, mở kho câu hỏi và xem kết quả.
- Danh sách bài kiểm tra gần đây.
- Biểu đồ điểm trung bình theo từng bài thi.
- Top học sinh đạt điểm cao.
- Các câu hỏi có nhiều lượt trả lời sai.
- Cảnh báo bài kiểm tra sắp hết hạn trong vòng ba ngày.
- Nền minh họa doodle pastel dành riêng cho không gian giáo viên.

### Dành cho học sinh

- Vào phòng thi bằng mã bài kiểm tra.
- Nhập họ tên để bắt đầu làm bài.
- Hiển thị đồng hồ đếm ngược và tiến độ làm bài.
- Hỗ trợ xáo trộn câu hỏi và đáp án.
- Tự động lưu bài làm khi chọn đáp án và định kỳ trong quá trình thi.
- Có thể tiếp tục bài đang làm nếu tải lại trang hoặc kết nối mạng bị gián đoạn.
- Tự động nộp bài khi hết giờ hoặc vượt quá số lần vi phạm cho phép.
- Xem điểm, phần trăm và số câu đúng sau khi nộp.
- Xem chi tiết đáp án nếu giáo viên cho phép.

## Công nghệ sử dụng

- HTML5, CSS3 và JavaScript thuần.
- Tailwind CSS CDN.
- Supabase Auth và Supabase Database.
- Chart.js cho biểu đồ.
- SheetJS cho xuất Excel.
- jsPDF và AutoTable cho xuất PDF.
- QRCode.js cho tạo mã QR bài thi.
- GitHub Pages để triển khai giao diện tĩnh.

## Cấu trúc chính

```text
.
├── index.html                    Trang chủ học sinh
├── student.html                  Giao diện làm bài
├── teacher-login.html            Đăng nhập và đăng ký giáo viên
├── teacher.html                  Dashboard và trang quản trị giáo viên
├── supabase-config.js            Cấu hình kết nối Supabase
├── setup.sql                     Cấu trúc bảng và chính sách Supabase
├── shared.css                    CSS dùng chung
├── teacher-dashboard-doodle-bg.svg
├── teacher-character.svg
├── empty-state.svg
└── server.js                     Máy chủ phục vụ file tĩnh khi chạy cục bộ
```

## Cài đặt Supabase

1. Tạo một project tại Supabase.
2. Mở SQL Editor và chạy nội dung trong `setup.sql`.
3. Kiểm tra các bảng chính:
   - `teachers`
   - `questions`
   - `tests`
   - `submissions`
4. Cập nhật URL project và anon key trong `supabase-config.js`.
5. Trong Supabase Authentication, cấu hình Email Provider theo nhu cầu.
6. Thêm domain triển khai vào phần URL Configuration nếu sử dụng xác thực email hoặc các chức năng chuyển hướng.

Không đưa `service_role key` hoặc khóa bí mật vào mã nguồn frontend. Frontend chỉ được sử dụng anon key và phải cấu hình Row Level Security phù hợp.

## Chạy cục bộ

Có thể mở trực tiếp các file HTML, nhưng nên dùng máy chủ tĩnh để tránh lỗi khi tải tài nguyên và module trình duyệt.

```bash
node server.js
```

Sau đó truy cập địa chỉ local do máy chủ hiển thị trên terminal.

## Triển khai GitHub Pages

1. Đưa toàn bộ mã nguồn lên repository GitHub.
2. Vào **Settings → Pages**.
3. Chọn nguồn triển khai từ branch chứa mã nguồn, thư mục `/root`.
4. Lưu cấu hình và chờ GitHub Pages hoàn tất triển khai.
5. Mở trang chủ từ domain GitHub Pages của repository.

Sau mỗi lần cập nhật, cần đợi GitHub Pages build xong và dùng `Ctrl + F5` để tải lại tài nguyên mới trên trình duyệt.

## Quy trình sử dụng nhanh

### Giáo viên

1. Mở trang đăng nhập giáo viên.
2. Đăng ký hoặc đăng nhập tài khoản.
3. Từ Dashboard, tạo câu hỏi hoặc tạo bài kiểm tra.
4. Chia sẻ mã bài thi hoặc mã QR cho học sinh.
5. Theo dõi kết quả trong mục **Kết quả & Thống kê**.
6. Xuất Excel hoặc PDF khi cần lưu trữ.

### Học sinh

1. Mở trang chủ.
2. Nhập mã bài kiểm tra.
3. Nhập họ tên và bắt đầu làm bài.
4. Chọn đáp án, kiểm tra tiến độ và nộp bài.
5. Xem kết quả sau khi nộp nếu bài thi cho phép.

## Lưu ý về tính điểm

- Tổng điểm bài thi được lấy từ trường `tests.total_points`.
- Điểm của mỗi bài nộp được lưu trong `submissions.score` và `submissions.total_points`.
- Trang giáo viên ưu tiên `submissions.total_points` khi quy đổi điểm về thang 10 để bảo đảm kết quả lịch sử không bị tính sai.
- Điểm hiển thị được làm tròn đến một chữ số thập phân.
- Điểm trừ do giáo viên nhập được áp dụng sau khi quy đổi điểm về thang 10.

## Bảo mật và dữ liệu

- Không chia sẻ anon key ngoài phạm vi cần thiết và tuyệt đối không đưa service role key lên GitHub.
- Kiểm tra Row Level Security trước khi đưa hệ thống vào sử dụng thực tế.
- Sao lưu dữ liệu Supabase định kỳ.
- Kiểm tra đáp án đúng sau khi nhập câu hỏi từ Word hoặc tạo câu hỏi bằng AI.
- Không chỉnh sửa đáp án câu hỏi sau khi đã có học sinh nộp bài nếu cần bảo toàn tính nhất quán của kết quả lịch sử.
