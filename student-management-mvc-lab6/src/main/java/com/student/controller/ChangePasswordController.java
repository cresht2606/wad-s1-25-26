import com.student.dao.UserDAO;
import com.student.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/change-password")
public class ChangePasswordController extends HttpServlet {
    
    private UserDAO userDAO;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Show change password page
        request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // TODO: Get current user from session
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("id");
                
        // TODO: Get form parameters (currentPassword, newPassword, confirmPassword)
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Create a user to verify
        User user = userDAO.getUserById(userId);
        
        // TODO: Validate current password
       if(!BCrypt.checkpw(currentPassword, user.getPassword())){
           request.setAttribute("error", "Current password is incorrect.");
           request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
           return;
       }
        
        // TODO: Validate new password (length, match)
        if(!newPassword.matches(currentPassword)){
            request.setAttribute("error", "New password does not match with current one");
            request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
            return;
        }
        
        if(newPassword.length() < 6){
            request.setAttribute("error", "New password length is too short");
            request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
            return;
        }
        
        // TODO: Hash new password
        String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        
        // TODO: Update in database
        boolean success = userDAO.updatePassword(userId, hashedPassword);
        
        // TODO: Show success/error message
        if (success){
            request.setAttribute("message", "Password changed successfully.");
        } else {
            request.setAttribute("error", "Failed to update password.");
        }
        
        request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
        
    }
}
