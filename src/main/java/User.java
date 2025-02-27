public class User {
    private int id;
    private String username;
    private String email;
    private String telephone;

    public User() {}
    public User(String username, String email, String telephone) {
        this.username = username;
        this.email = email;
        this.telephone = telephone;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }
}