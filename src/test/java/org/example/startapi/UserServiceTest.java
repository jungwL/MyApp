package org.example.startapi;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class UserServiceTest {

    @Test
    void login_정상작동() {
        UserService userService = new UserService();
        UserDTO user = userService.login("test1@test.com", "1234");

        assertNotNull(user);
        assertEquals("홍길동", user.getUserName());
        assertEquals(100, user.getUserPoint());
    }
}
