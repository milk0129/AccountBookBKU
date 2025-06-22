// 쿠키 읽기 함수
function getCookie(name) {
  const value = `; ${document.cookie}`;
  const parts = value.split(`; ${name}=`);
  if (parts.length === 2) return parts.pop().split(';').shift();
}

// 쿠키 저장 함수
function setCookie(name, value, days) {
  const expires = new Date(Date.now() + days * 864e5).toUTCString();
  document.cookie = `${name}=${value}; path=/; expires=${expires}`;
}

// 테마 전환 버튼용 함수
function toggleTheme() {
  const isDark = document.body.classList.toggle('dark-theme');
  setCookie('theme', isDark ? 'dark' : 'light', 30);
}

// 페이지 로드시 쿠키에 따라 다크모드 적용
window.addEventListener('DOMContentLoaded', () => {
  const savedTheme = getCookie('theme');
  if (savedTheme === 'dark') {
    document.body.classList.add('dark-theme');
  }
});
