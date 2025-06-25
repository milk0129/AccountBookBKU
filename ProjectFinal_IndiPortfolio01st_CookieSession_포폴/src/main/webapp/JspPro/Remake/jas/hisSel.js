let dateInput;
let itemInput;
let moneyInput;
let categoryInput;
let memoInput;

// 입력창 초기 연결
function mInit() {
    dateInput = document.getElementById("mdate");
    itemInput = document.getElementById("mItem");
    moneyInput = document.getElementById("mMoney");
    categoryInput = document.getElementById("mCategory");
    memoInput = document.getElementById("mMemo");
}

// 🗑 버튼 누르면 입력창 전체 초기화
function mReset() {
    if (dateInput) dateInput.value = "";
    if (itemInput) itemInput.value = "";
    if (moneyInput) moneyInput.value = "";
    if (categoryInput) categoryInput.value = "";
    if (memoInput) memoInput.value = "";

    const incomeRadio = document.getElementById('income');
    const outcomeRadio = document.getElementById('outcome');

    if (incomeRadio) incomeRadio.checked = false;
    if (outcomeRadio) outcomeRadio.checked = false;
}

function validateForm() {
    const expTypeIncome = document.getElementById("income");
    const expTypeOutcome = document.getElementById("outcome");
    const mdate = document.getElementById("mdate");
    const mMoney = document.getElementById("mMoney");
    const mCategory = document.getElementById("mCategory");
    const customCategory = document.getElementById("customCategory");
    const mItem = document.getElementById("mItem");

    let resultMsg = "";

    // 1. 수입/지출 선택 확인
    if (!expTypeIncome.checked && !expTypeOutcome.checked) {
        resultMsg = "⚠ 수입 또는 지출을 선택해주세요.";
    }
    // 2. 날짜 입력 확인
    else if (mdate.value.trim() === "") {
        resultMsg = "⚠ 날짜를 입력해주세요.";
    }
    // 3. 금액 입력 확인
    else if (mMoney.value.trim() === "") {
        resultMsg = "⚠ 금액을 입력해주세요.";
    }
    // 4. 카테고리 직접입력 확인
    else if (mCategory.value === "기타" && customCategory.value.trim() === "") {
        resultMsg = "⚠ 카테고리를 직접 입력해주세요.";
    }
    // 5. 항목 입력 확인
    else if (mItem.value.trim() === "") {
        resultMsg = "⚠ 항목을 입력해주세요.";
    }

    // 유효성 실패 시 메시지 출력
    if (resultMsg !== "") {
        document.getElementById("resultMsg").style.color = "black";
        document.getElementById("resultMsg").innerText = resultMsg;
        return false;
    }

    // 기타 선택 시 사용자 입력값을 option으로 추가하고 selected로 설정
    if (mCategory.value === "기타" && customCategory.value.trim() !== "") {
        const customValue = customCategory.value.trim();

        // 기존 모든 옵션 selected 해제
        Array.from(mCategory.options).forEach(opt => {
            opt.selected = false;
        });

        // 동일한 option 존재 여부 확인
        let targetOption = Array.from(mCategory.options).find(opt => opt.value === customValue);

        // 없다면 새로 추가
        if (!targetOption) {
            targetOption = new Option(customValue, customValue);
            mCategory.add(targetOption);
        }

        // 선택 상태로 만들기
        targetOption.selected = true;
    }

    return true;
}

function toggleCustomCategory() {
    const select = document.getElementById("mCategory");
    const customInput = document.getElementById("customCategory");

    if (select.value === "기타") {
        customInput.style.display = "inline-block";
    } else {
        customInput.style.display = "none";
        customInput.value = ""; // 기타가 아니면 입력 비우기
    }
}

function submitWithMonth() {
    // 현재 달력의 yearMonth 값을 가져와서 hidden 필드에 복사
	const calendarInput = document.querySelector("#calendarFrm #yearMonth");
	const monthFromCalendar = calendarInput ? calendarInput.value : "";
    // history 폼 내부 input에 반영
    if (monthFromCalendar) {
        document.querySelector("#myForm #yearMonth").value = monthFromCalendar;
        document.querySelector("#myForm #selectedMonth").value = monthFromCalendar;
    }

    // 최종적으로 form 전송
    document.getElementById("myForm").submit();
}