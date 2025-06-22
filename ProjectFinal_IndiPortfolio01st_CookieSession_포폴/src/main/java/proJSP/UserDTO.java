package proJSP;

public class UserDTO {
    private String userId;
    private String userName;
    private String userBirth; 

    public UserDTO(String userId, String userName, String userBirth) {
        this.userId = userId;
        this.userName = userName;
        this.userBirth = userBirth;
    }

    public String getUserId() {
        return userId;
    }

    public String getUserName() {
        return userName;
    }

    public String getUserBirth() {
        return userBirth;
    }
}