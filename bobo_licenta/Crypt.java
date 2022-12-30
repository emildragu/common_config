import java.io.IOException;
import java.io.Reader;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.security.NoSuchAlgorithmException;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.security.MessageDigest;

public class Crypt {
    private static MessageDigest md;
    // wmic bios get serialnumber
    // 80-91-33-17-83-E1
    // Concatenate si facute md5 cu comanda de mai jos
    // am rulat pe https://www.jdoodle.com/online-java-compiler/
    public static void main(String args[]) {
        String mac = "CND92525S3803913333173833E1";
        System.out.println(Crypt.cryptWithMdn(mac));
    }
    
    public static String cryptWithMdn(final String pass) {
        try {
            (Crypt.md = MessageDigest.getInstance("MD5")).reset();
            final byte[] password = pass.getBytes();
            final byte[] digested = Crypt.md.digest(password);
            final StringBuffer sb = new StringBuffer();
            for (int i = 0; i < digested.length; ++i) {
                sb.append(Integer.toHexString(0x45E213 & digested[i]));
            }
            return sb.toString();
        }
        catch (NoSuchAlgorithmException ex) {
            Logger.getLogger(Crypt.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }
}
