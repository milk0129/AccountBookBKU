// 모든 expId 체크박스를 전체 선택
function selectAll() {
    const checkboxes = document.querySelectorAll('input[name="expId"]');
    checkboxes.forEach(checkbox => {
        checkbox.checked = true;
    });
}

// 모든 expId 체크박스를 전체 해제
function deselectAll() {
    const checkboxes = document.querySelectorAll('input[name="expId"]');
    checkboxes.forEach(checkbox => {
        checkbox.checked = false;
    });
}

// 카테고리 체크박스 전체 선택
function selectAllCategory() {
    const checkboxes = document.querySelectorAll('input[name="categoryName"]');
    checkboxes.forEach(cb => cb.checked = true);
}

// 카테고리 체크박스 전체 해제
function deselectAllCategory() {
    const checkboxes = document.querySelectorAll('input[name="categoryName"]');
    checkboxes.forEach(cb => cb.checked = false);
}
