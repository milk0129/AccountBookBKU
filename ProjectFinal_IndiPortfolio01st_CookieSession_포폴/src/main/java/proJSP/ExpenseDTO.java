package proJSP;

public class ExpenseDTO {
    private int expId;             // 고유 ID
    private String userId;         // 소유자 ID
    private String expDate;        // 날짜 (yyyy-MM-dd)
    private String expItem;        // 항목명
    private int expMoney;          // 금액
    private String expType;        // 수입 or 지출
    private String expCategory;    // 카테고리
    private String expMemo;        // 메모

    // 기본 생성자
    public ExpenseDTO() {}

    // 전체 필드 생성자
    public ExpenseDTO(int expId, String userId, String expDate, String expItem,
                      int expMoney, String expType, String expCategory, String expMemo) {
        this.expId = expId;
        this.userId = userId;
        this.expDate = expDate;
        this.expItem = expItem;
        this.expMoney = expMoney;
        this.expType = expType;
        this.expCategory = expCategory;
        this.expMemo = expMemo;
    }

    // 등록용 생성자 (expId 자동 증가 시 제외)
    public ExpenseDTO(String userId, String expDate, String expItem,
                      int expMoney, String expType, String expCategory, String expMemo) {
        this.userId = userId;
        this.expDate = expDate;
        this.expItem = expItem;
        this.expMoney = expMoney;
        this.expType = expType;
        this.expCategory = expCategory;
        this.expMemo = expMemo;
    }

    // Getter & Setter
    public int getExpId() {
        return expId;
    }

    public void setExpId(int expId) {
        this.expId = expId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getExpDate() {
        return expDate;
    }

    public void setExpDate(String expDate) {
        this.expDate = expDate;
    }

    public String getExpItem() {
        return expItem;
    }

    public void setExpItem(String expItem) {
        this.expItem = expItem;
    }

    public int getExpMoney() {
        return expMoney;
    }

    public void setExpMoney(int expMoney) {
        this.expMoney = expMoney;
    }

    public String getExpType() {
        return expType;
    }

    public void setExpType(String expType) {
        this.expType = expType;
    }

    public String getExpCategory() {
        return expCategory;
    }

    public void setExpCategory(String expCategory) {
        this.expCategory = expCategory;
    }

    public String getExpMemo() {
        return expMemo;
    }

    public void setExpMemo(String expMemo) {
        this.expMemo = expMemo;
    }

    @Override
    public String toString() {
        return "[" + expId + "] " + expDate + " | " + expType + " | " +
               expItem + " | " + expMoney + "원 | " + expCategory + " | " + expMemo;
    }
}
