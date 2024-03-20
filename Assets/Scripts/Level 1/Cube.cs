using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Cube : MonoBehaviour
{
    // Start is called before the first frame update
    [SerializeField] private float jumpForce = 1;
    [SerializeField] private float maxCharge = 5;
    private float charge = 1;
    void Start()
    {
    }

    void FixedUpdate()
    {
        if (IsOnFloor() && Input.GetKeyUp(KeyCode.Space))
        {
            Debug.Log("Jumping with charge: " + charge);
            GetComponent<Rigidbody>().AddForce(Vector2.up * jumpForce * charge, ForceMode.Impulse);
            charge = 1;
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (IsOnFloor() && Input.GetKey(KeyCode.Space))
        {
            charge += Time.deltaTime;
            charge = Mathf.Min(maxCharge, charge);
        }
    }

    private bool IsOnFloor()
    {
        return transform.position.y <= 0.51f;
    }
}
