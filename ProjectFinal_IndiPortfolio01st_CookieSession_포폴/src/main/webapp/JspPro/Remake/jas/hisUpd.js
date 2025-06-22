let dateInput;
let itemInput;
let moneyInput;
let categoryInput;
let memoInput;

document.addEventListener('DOMContentLoaded', mInit);
document.addEventListener('DOMContentLoaded', toggleCustomCategory);

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
}

function validateForm() {
    const expTypeIncome = document.getElementById("income");
    const expTypeOutcome = document.getElementById("outcome");
    const mdate = document.getElementById("mdate");
    const mMoney = document.getElementById("mMoney");
    const mCategory = document.getElementById("mCategory");
    const customCategory = document.getElementById("customCategory");
    const mItem = document.getElementById("mItem");
    const resultMsgTag = document.getElementById("resultMsg");

    let resultMsg = "";

    if (!expTypeIncome.checked && !expTypeOutcome.checked) {
        resultMsg = "수입 또는 지출을 선택해주세요.";
    } else if (mdate.value.trim() === "") {
        resultMsg = "날짜를 입력해주세요.";
    } else if (mMoney.value.trim() === "") {
        resultMsg = "금액을 입력해주세요.";
    } else if (mCategory.value === "기타" && customCategory && customCategory.value.trim() === "") {
        resultMsg = "카테고리를 직접 입력해주세요.";
    } else if (mItem.value.trim() === "") {
        resultMsg = "항목을 입력해주세요.";
    }

    if (resultMsg !== "") {
        resultMsgTag.style.color = "black";
        resultMsgTag.innerText = resultMsg;
        return false;
    }

    // 정상일 때: 기타 처리
    if (mCategory.value === "기타" && customCategory && customCategory.value.trim() !== "") {
        const customValue = customCategory.value.trim();

        // select에 있는 option인지 확인
        let exists = Array.from(mCategory.options).some(opt => opt.value === customValue);

        if (!exists) {
            const newOption = new Option(customValue, customValue);
            mCategory.add(newOption);
        }

        mCategory.value = customValue;
    }

    return true;
}


function prepareCategory() {
    const select = document.getElementById("mCategory");
    const customInput = document.getElementById("customCategory");

    if (select.value === "기타(직접입력)" && customInput.value.trim() !== "") {
        select.value = customInput.value.trim();
    }
}

function toggleCustomCategory() {
    const mCategory = document.getElementById("mCategory");
    const customCategory = document.getElementById("customCategory");

    if (mCategory.value === "기타") {
        customCategory.style.display = "inline-block";
    } else {
        customCategory.style.display = "none";
        customCategory.value = "";
    }
}

// 페이지 로드시 '기타' 선택되어 있으면 입력창 자동 표시
window.onload = function() {
    toggleCustomCategory();
};


