@isTest
public class MathsisTest {
    
    @isTest public static void testaddition(){
        Integer add = Mathsis.addition(2,3);
        System.assertEquals(5, add);
    }
    @isTest public static void testmultiplication(){
        Integer add = Mathsis.multiply(5, 1);
        System.assertEquals(5, add);
    }
    @isTest public static void testdivide(){
        Decimal add = Mathsis.divide(10, 2);
        System.assertEquals(5, add);
    }
    @isTest public static void testsubstract(){
        Integer add = Mathsis.substract(15, 9);
        System.assertEquals(6, add);
    }
}